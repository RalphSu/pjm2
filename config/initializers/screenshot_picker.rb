#-- encoding: UTF-8
require 'rubygems'
require 'rufus/scheduler'
require 'nokogiri'
require 'open-uri'

class ScreenshotPicker
	include NewsReleaseHelper

	# call by given a date
	# TODO: should we batch to reduce the phantom js start overhead??
	def screenshot_job(end_date)
		while true
			now = Time.now()
			if now > end_date
				break
			end
			job = nil
			begin 
				js = get_screen_js
				Rails.logger.info " get _screen _js #{js}"
				phantom = get_phantom
				Rails.logger.info " js file location: #{js}, phantom runtime location:#{phantom}"

				job = ScreenshotJob.find(:first, :order=>"created_at desc")
				Rails.logger.info "job is #{job.inspect}"
				if job.blank? or job.news_release.blank? or job.news_release.project.blank? or job.news_release.url.blank?
					Rails.logger.info 'find not screenshot jobs, wait and next'
					sleep(10.seconds)
					next
				end
				url = job.news_release.url

				img = Image.find(:first, :conditions=>{:url => job.news_release.url, :image_date=> job.news_release.image_date})
				unless img.blank?
					Rails.logger.info "image for url: #{url}, date : #{job.news_release.image_date}, already exists, ignore this capture!"
					ScreenshotJob.destroy(job.id)
					sleep(3.seconds)
					next
				end

				# generate file_path
				# full_name : the full path that the image to be saved
				# relative_path : the relative_path that 
				paths=get_and_check_file_path(job.news_release.project)
				full_name=paths[0]
				relative_path = paths[1]

				Rails.logger.info "url is #{url}, file full name is #{full_name} !, relative_path to be stored is #{relative_path} !"

				Rails.logger.info "#{phantom} #{js} #{url} #{full_name}"
				capture_status = `#{phantom} --load-images=false #{js} #{url} #{full_name}`
				Rails.logger.info "capture_status is #{capture_status}"

				# save image
				img = Image.new
				img.url= job.news_release.url
				img.image_date = job.news_release.image_date
				img.file_path = relative_path
				img.save!

				Rails.logger.info "remove current screen job!"
				ScreenshotJob.destroy(job.id)
			rescue Exception => e
				unless job.nil?
					ScreenshotJob.destroy(job.id)
				end
				Rails.logger.info "Screenshot failed. url: #{url} !! Exception is #{e.inspect}"
				sleep(10.seconds)
			end
		end

		Rails.logger.info "Screenshot running round completed. The end_date is #{end_date}, current time is #{Time.now}"
	end

	def get_screen_js
		File.join File.dirname(__FILE__), "../../screenshots/screen_capture.js"
	end

	def get_phantom
		phantom = ENV['PHANTOM_HOME'] + "/bin/phantomjs"
	end

	def get_and_check_file_path(project)
		prefix = File.join File.dirname(__FILE__), "../../"
		relative_path = "/public/upload/#{project.identifier}/"
		folder = File.join prefix, relative_path
		unless File.exists?(folder)
			Dir.mkdir(folder)
		end
		uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
		file_full_name = "screenshot--" + uuid + '.png'
		# append the file name to the relative path
		relative_path = File.join relative_path,file_full_name
		full_name = File.join prefix, relative_path
		return [full_name, relative_path]
	end

	# def keepLatestJobs(keep_num)
	# 	top_jobs = ScreenshotJob.find(:all, :order => "created_at desc", :limit=> keep_num)
	# 	last_id = nil
	# 	if top_jobs.size >= keep_num
	# 		last_id = top_jobs[keep_num - 1].id
	# 	end
	# 	unless last_id.nil?
	# 		# delete the jobs
	# 	end
	# end
end


sys_picker = ScreenshotPicker.new
#sys_picker.screenshot_job(Time.now + (10))
# just new a thread and run it??
# i'm not sure what would happend to thread like interruptted in java
# Thread.new do
# 	sys_picker.screenshot_job(Time.new)
# end

# use scheduler to periodically call the screenshot method. This method should
# not exit until time slide way. This way, we make sure if something unexpected happens,
# the schedule will call the picker again. Overhead is that there might small time windows
# that differnt round of screenshot_job working on the one image screen shot. We treat this case
# as minor case, and it won't hurt anything:)
scheduler = Rufus::Scheduler.new
scheduler.every("6h") do
	Rails.logger.info " Start screenshot job at #{Time.now}"
 	sys_picker.screenshot_job(Time.now + (6 * 60 * 60 * 24))
end

# scheduler.every("1d") do
# 	Rails.logger.info " Delete un-complete screenshot jobs at #{Time.now}"
#  	sys_picker.screenshot_job(100)
# end
