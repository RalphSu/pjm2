#-- encoding: UTF-8
require 'rubygems'
require 'rufus/scheduler'
require 'nokogiri'
require 'open-uri'

class Crawler

	def do_crawl
		Project.find(:all, :conditions=> {:status => Project::STATUS_ACTIVE}).each do |p|
			#crawl_project(p)
			puts p.name + " :: " + Time.now.to_s
		end
	end

	# could be a api for manually trigger project crawling
	def crawl_project(project)
		news_classifieds_hash = {}
		NewsClassified.find(:all, :conditions=>{:classified=> '新闻稿推广'}).each do |n|
			news_classifieds_hash[n.template.column_name] = n
		end
		start_time = Time.now.to_s
		# crawl for project, and store the crawler job status : projectId, star_time, end_time, num_of_pages_read, num_of_item_saved
		# send key word and fetch each page, iterating on each page
		saved_count = 0
		num_of_pages_read = 0
		page_url = "http://news.baidu.com/ns?"
		while (not page_url.nil)
			doc = Nokogiri::HTML(open(page_url))
			[next_page, count] = _handle_one_page(doc, project, news_classifieds_hash, num_of_pages_read+1)
			page_url = next_page
			saved_count = saved_count + count
			num_of_pages_read = num_of_pages_read + 1
			# sleep( 1000ms) to avoid baidu blocking.
		end
		end_time = Time.now.to_s
	end

	# return [next_page, saved_count]
	def _handle_one_page(doc, project, news_classifieds_hash, page_num)
		saved_count = 0
		item_count = 0
		next_page = nil
		doc.search('//div/ul/li').each do |item|
			# create news_release line
			begin
				nr = NewsRelease.new
				nr.project = project
				nr.classified = '新闻稿推广'

				fields = []
				# puts "found one item, now processing "
				# puts item.content
				item.search('.//h3/a').each do |link|
					# puts "Url: " + link['href']
					f = NewsReleaseField.new
					f.body = link['href']
					f.news_classified = news_classifieds_hash['链接']
					fields << f

					#puts "Title: " + link.content
					f = NewsReleaseField.new
					f.body = link.content
					f.news_classified = news_classifieds_hash['标题']
					fields << f
				end

				# regular expression??
				item.css('span').each do |author_time|
					content = author_time.content.strip;
					#puts "Author and time : " + content
					date_len = "2013-12-30 09:27:00".length
					if content.length < date_len
						site = content
						time = ""
					else
						time = content[(0-date_len)..-1]
						site = content[0, (content.length - date_len)]
					end

					#puts "Site: " + site
					f = NewsReleaseField.new
					f.body = site
					f.news_classified = news_classifieds_hash['发布平台']
					fields << f
					#puts "Time: " + time
					f = NewsReleaseField.new
					f.body = time
					f.news_classified = news_classifieds_hash['日期']
					fields << f
				end

				# now save
				if _save(nr, fields)
					saved_count = saved_count + 1
				end
				item_count = item_count + 1
			rescue Exception 
				Rails.logger.error "Ignore failure when hande project #{project.name} for page at #{page_num}, item index : #{item_count}. The item content is #{item.content} !!!"
			end # end of try catch
		end # end of each result

		# check for next page
		doc.search('//div/div/p/a').each do |item|
			if '下一页>' == item.content
				next_page = item['href']
			end
		end
		[next_page, saved_count]
	end

	def _save(nr, fields)
		unless fields.blank?
			begin
				ActiveRecord::Base.transaction do
					nr.save()
					fields.each do |f|
						f.news_release=nr
						f.save
					end
				end  # end of transaction
			rescue Exception
				Rails.logger.info "Save an extracted news release failed caused by ActiveRecord save. #{nr.inspect} #{fields.inspect}"
			end
			begin
				# now save news
				@news = News.new(:project => nr.project, :author => User.find(:conditions=>{:admin=>1}))
				@news.summary="百度网页抓取"
				@news.title="百度网页抓取"
				@news.description="百度网页抓取后台"
				if @news.save
					Rails.logger.info "save news success"
				else
					Rails.logger.info "save  news failed"
					Rails.logger.info(@news.errors.inspect) 
				end
			rescue Exception
				Rails.logger.info "save  news failed. -- baidu_crawler"
			end
			return true
		end
		return false
	end
end

scheduler = Rufus::Scheduler.new
sys_crawler = Crawler.new

#scheduler.cron '5 0 * * *' do
scheduler.every("2m") do
	sys_crawler.do_crawl()
end