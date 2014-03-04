#-- encoding: UTF-8
require 'rubygems'
require 'rufus/scheduler'
require 'nokogiri'
require 'open-uri'

class Crawler
	include NewsReleaseHelper

	def do_crawl
		nr = NewsRelease.new()
		nr.url = 'abc'
		nr.image_date = 'def'
		nr.classified = 'def'

		Project.find(:all, :conditions=> {:status => Project::STATUS_ACTIVE}).each do |p|
			puts "Start crawler for project :#{p.name}, time : #{Time.now.to_s} "
			crawl_project(p)
		end
	end

	# could be a api for manually trigger project crawling
	def crawl_project(project)
		news_classifieds_hash = {}
		NewsClassified.find(:all, :conditions=>{:classified=> '新闻稿推广'}).each do |n|
			news_classifieds_hash[n.template.column_name] = n
		end

		puts news_classifieds_hash
		
		# crawl for project, and store the crawler job status : project id, star_time, end_time, num_of_pages_read, num_of_item_saved
		# send key word and fetch each page, iterating on each page
		saved_count = 0
		start_time = Time.now.to_s
		num_of_pages_read = 0
		init = _get_init_url(project)
		page_url = init[0]
		puts "init url for project #{project.name}: #{page_url}"
		search_query_begin_date = init[1]
		search_query_end_date = init[2]

		job = _create_job(project, page_url, saved_count, num_of_pages_read, start_time, search_query_begin_date, search_query_end_date)

		# start crawl
		while (not page_url.blank?)
			begin 
				puts "	handling page #{num_of_pages_read} with url: #{page_url}	"
				doc = Nokogiri::HTML(open(page_url))
				stat = _handle_one_page(job, doc, project, news_classifieds_hash, num_of_pages_read+1)
				page_url = stat[0]
				saved_count = saved_count + stat[1]
				num_of_pages_read = num_of_pages_read + 1
				puts "Crawler done for project #{project.name}, page number #{num_of_pages_read}, saved item count : #{saved_count}!"
				# sleep( 1000ms) to avoid baidu blocking.
				sleep 2
			rescue Exception => e
				puts "crawl failed with exception #{e.inspect}!"
				page_url = nil
				break		
			end
		end
		end_time = Time.now.to_s

		_update_job(job, end_time, num_of_pages_read, saved_count)
		_save_news_event(project)
	end

	def _create_job(project, page_url, saved_count, num_of_pages_read, start_time, search_query_begin_date, search_query_end_date)
		begin
			job = CrawlerJob.new
			job.project_id = project.id
			job.init_url = page_url
			job.num_of_pages = num_of_pages_read
			job.saved_count = saved_count
			job.start_time = start_time
			job.search_query_begin_date = search_query_begin_date
			job.search_query_end_date = search_query_end_date
			job.save!()
			job
		rescue Exception
			puts 'Save crawler job faild caused by database error!'
		end
	end

	def _update_job(job, end_time, num_of_pages_read, saved_count)
		begin
			job.end_time = end_time
			job.num_of_pages = num_of_pages_read
			job.saved_count = saved_count
			job.save!
		rescue Exception
			puts 'Save crawler job faild caused by database error!'
		end
	end

	def _get_init_url(project)
		news = 'news'
		last_day = Time.now - (60 * 60 * 24)
		today = Time.now
		start_time = Time.new(last_day.year, last_day.month, last_day.day)
		end_time = Time.new(today.year, today.month, today.day)
		bt = start_time.to_i
		y0 = start_time.year
		m0 = start_time.month
		d0 = start_time.day
		y1 = end_time.year
		m1 = end_time.month
		d1 = end_time.day
		begin_date = start_time.strftime('%Y-%m-%d')
		end_date = end_time.strftime('%Y-%m-%d')
		et = end_time.to_i
		cl = 2
		ct1 = 1
		ct = 1
		q1 = ""
		unless project.keywords.blank?
			words = _get_query_words(project.keywords)
			q1 = URI.encode(words.join(' '))
		end 
		q4 = ""
		unless project.keywords_except.blank?
			words = _get_query_words(project.keywords_except)
			q4 = URI.encode(words.join(' '))
		end
		tn = 'newsdy'
		rn = 20
		url = "http://news.baidu.com/ns?from=#{news}&bt=#{bt}&y0=#{y0}&m0=#{m0}&d0=#{d0}&y1=#{y1}&m1=#{m1}&d1=#{d1}&cl=#{cl}&et=#{et}&ct1=#{ct1}&ct=#{ct}&q1=#{q1}&q4=#{q4}&tn=#{tn}&rn=#{rn}&begin_date=#{begin_date}&end_date=#{end_date}"
		[url, start_time, end_time]
	end

	def _get_query_words(word_split_with_comma)
		keywords = word_split_with_comma.split(';')
		words = []
		keywords.each do |k|
			words.concat(k.split('；'))
		end
		return words
	end

	# return [next_page, saved_count]
	def _handle_one_page(job, doc, project, news_classifieds_hash, page_num)
		saved_count = 0
		item_count = 0
		next_page = nil
		#Rails.logger.info doc
		doc.search('//div/ul/li').each do |item|
			# create news_release line
			# puts item.content
			begin
				nr = NewsRelease.new
				nr.project = project
				nr.classified = '新闻稿推广'
				nr.crawler_job = job

				fields = []
				# puts "found one item, now processing "
				# puts item.content
				item.search('.//h3/a').each do |link|
					# puts "Url: " + link['href']
					f = NewsReleaseField.new
					f.body = link['href']
					nr.url = f.body
					f.news_classified = news_classifieds_hash['链接']
					fields << f

					#puts "Title: " + link.content
					f = NewsReleaseField.new
					f.body = link.content
					f.news_classified = news_classifieds_hash['标题']
					fields << f
				end

				# use regular expression??
				hasDate = false
				hasPlatform = false
				item.css('span').each do |author_time|
					content = author_time.content.strip;
					#puts "Author and time : " + content
					date_len = "2013-12-30 09:27:00".length
					time_len = " 09:27:00".length
					if content.length < date_len
						site = content
						time = ""
					else
						time = content[(0-date_len)..(0 - time_len)]
						site = content[0, (content.length - date_len)]
					end

					Rails.logger.info "Site: " + site
					unless site.blank?
						hasPlatform = true
						f = NewsReleaseField.new
						f.body = site
						f.news_classified = news_classifieds_hash['发布平台']
						fields << f
					end 

					Rails.logger.info "Time: " + time
					begin
						# validate time before save. If time parse failed, then don't save this time.
						d = Date.strptime(time, "%Y-%m-%d")
						if not d.nil?
							hasDate = true
							f = NewsReleaseField.new
							f.body = d.to_s
							nr.image_date = f.body
							f.news_classified = news_classifieds_hash['日期']
							fields << f
						else
							raise "Invalid date string."
						end
					rescue Exception => e
						Rails.logger.info " BaiduCrawler :: Parse time error, ignore the date save of illegal time string #{time}, exception is #{e.inspect}!!"
					end
				end

				# ignore no date items, they might be baidu links that is not search results, like search suggestions
				# ignore for platform
				unless (hasDate and hasPlatform)
					Rails.logger.info "Ignore no date in parsed output when hande project #{project.name} for page at #{page_num}, item index : #{item_count}. The item content is #{item.content}!"
					next
				end


				# now save
				if _save(nr, fields)
					saved_count = saved_count + 1
				end
			rescue Exception => e
				Rails.logger.info "Ignore failure when hande project #{project.name} for page at #{page_num}, item index : #{item_count}. The item content is #{item.content}! Exception : #{e.inspect}"
			ensure
				item_count = item_count + 1
			end # end of try catch
		end # end of each result

		# check for next page
		doc.search('//div/div/p/a').each do |item|
			if '下一页>' == item.content
				next_page = 'http://news.baidu.com' + item['href']
			end
		end
		[next_page, saved_count]
	end

	def _save(nr, fields)
		Rails.logger.info "	Saved #{nr.inspect} and #{fields.inspect} for one news_release line!"
		unless fields.blank?
			# check duplicated.
			duplicated = find_duplicate(nr, fields)
			unless duplicated.blank?
				return false
			end

			saved = false
			begin
				ActiveRecord::Base.transaction do
					nr.save!
					fields.each do |f|
						f.news_release=nr
						f.save!
					end
					# save screenshot jobs
					screenjob = ScreenshotJob.new
					screenjob.news_release = nr
					screenjob.save!
				end  # end of transaction
				saved = true
			rescue Exception => e
				puts "Save an extracted news release failed caused by ActiveRecord save. #{nr.inspect} #{fields.inspect}. Exception : #{e}!!"
				return saved
			end
			return saved
		end
		return false
	end

	def _save_news_event(project)
		begin
			puts "	add news for this item"
			# now save news
			news = News.new(:project => project, :author => User.find(:all, :conditions=>{:admin=>1}).first)
			news.summary="百度网页抓取"
			news.title="百度网页抓取"
			news.description="百度网页抓取后台"
			if news.save
				puts "save news success"
			else
				puts "save  news failed"
				puts(news.errors.inspect) 
			end
		rescue Exception => e
			puts "Save news event failed caused by ActiveRecord save. #{news}. Exception : #{e}!!"
		end
	end
end

scheduler = Rufus::Scheduler.new
sys_crawler = Crawler.new

# scheduler.cron '5 0 * * *' do
scheduler.every("2h") do
# scheduler.every("2m") do
 	sys_crawler.do_crawl()
end
#sys_crawler.do_crawl()