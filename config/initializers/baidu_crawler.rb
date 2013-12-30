require 'rubygems'
require 'rufus/scheduler'
require 'nokogiri'
require 'open-uri'

scheduler = Rufus::Scheduler.new
sys_crawler = Crawler.new

scheduler.every("2s") do
	sys_crawler.do_crawl()
end

class Crawler

	def do_crawl
		Project.find(:all, :conditions=> {:status => Project::STATUS_ACTIVE}).each do |p|
			#crawl_project(p)
			puts p.name + " :: " + Time.now.to_s
		end
	end

	# could a api for manually trigger project crawling
	def crawl_project(project)
		# crawl for project, and store the crawler job status : star_time, end_time, num_of_pages_read, num_of_items_added
		# send key word and fetch each page, iterating on each page
	end

	def _handle_one_page(doc)
		doc.search('//div/ul/li').each do |item|
			puts "found one item, now processing "
			# puts item.content
			item.search('.//h3/a').each do |link|
				puts "Url: " + link['href']
				puts "Title: " + link.content
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
				puts "Site: " + site
				puts "Time: " + time
			end

			## summary 
			#item.css('div').each do |summary|
			#  puts summary.content
			#end
			puts "end of item \n\n\n"
		end
	end
end

