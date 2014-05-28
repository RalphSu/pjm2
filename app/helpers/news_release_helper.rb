#-- encoding: UTF-8

module NewsReleaseHelper

	def news_release_option_for_select(selected)
		container = []
		container << ["", ""]
		NewsClassified.all(:select => "DISTINCT(classified)").each do |n|
			container << [n.classified, n.classified]
		end
		options_for_select(container, selected)
	end

	def find_new_classifieds(classified)
		# select * from news_classified where classified = '@@@'
		NewsClassified.find(:all, :conditions => {:classified =>classified })
	end

	def find_news_classified_hash
		# hash of hash  classified => { template_name => NewsClassified }
		map = {}
		NewsClassified.all.each  do |f|
			if map.has_key?(f.classified)
				map[f.classified][f.template.column_name] = f
			else
				inner_map = {}
				inner_map[f.template.column_name] = f
				map[f.classified] = inner_map
			end
		end
		map
	end

	def count_news_releases(project, category)
		NewsRelease.count_by_sql "SELECT COUNT(*) FROM news_releases n WHERE n.project_id = #{project.id} and classified = '#{category}' "
	end

	def find_news_release_for_project(project, category, link, link_date)
		conditions = []
		sql = "project_id = ? AND classified = ? "
		sql_param = []
		sql_param << project.id
		sql_param << category
		unless link.blank?
			sql = sql + " AND url REGEXP ? "
			sql_param << link
		end
		unless link_date.blank?
			sql = sql + " AND image_date = ? "
			sql_param << link_date
		end
		conditions << sql
		conditions.concat sql_param
		Rails.logger.info " conditions for query is #{conditions.inspect}"
		if category == "新闻稿推广"
			NewsRelease.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'image_date asc',:conditions=>conditions)
		else
			NewsRelease.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'image_date desc',:conditions=>conditions)
		end
	end

	def distinct_news_templates
		Template.find(:all, :conditions => {:template_type =>"新闻类模板" })
	end

	def distinct_news_classifieds
		NewsClassified.all(:select => "DISTINCT(classified)")
	end

	def find_field_by_releaseId(releaseId)
		field = NewsReleaseField.find(:all, :conditions=>{:news_releases_id=>releaseId})
			# ,
			# :joins => "LEFT JOIN images on images.url=news_release_fields.body",
			# :select => "news_release_fields.*,images.file_path AS file_path ")
		if field.blank?
			map = {}
		else
			map = {}
			## check image path
			## find date column and link column
			date_field = nil
			link_field = nil
			field.each do |f|
				if f.news_classified.template.column_name == "日期" and (not f.body.blank?)
					date_field = f
				elsif f.news_classified.template.column_name == "链接" and (not f.body.blank?)
					link_field = f
				end
			end
			# find correct _image 
			if (not date_field.blank?) and (not link_field.blank?)
				begin
					date = Date.strptime(date_field.body, "%Y-%m-%d")
					img = Image.find(:first, :conditions=> {:url => link_field.body, :image_date=> date})
					unless img.blank?
						link_field.file_path = img.file_path
					end
				rescue Exception => e
					Rails.logger.info e
				end
			end
			##
			field.each do |f|
				Rails.logger.info "file_path is #{f.file_path}!!!"
				map[f.news_classified.id] = f
			end
			map
		end
		# Rails.logger.info map
		map
	end

	class NewsReleaseFactory
		def createEntity(classified_name)
			nr  = NewsRelease.new()
			nr.classified = classified_name
			return nr
		end
		def createField(body, classified)
			field = NewsReleaseField.new()
			field.body = body
			field.news_classified = classified
			return field
		end
	end

	def find_duplicate(nr, fields)
		date = nil
		url = nil
		fields.each do |f|
			if f.news_classified.template.column_name == '日期'
				date = f
				nr.image_date = date.body
			end
			if f.news_classified.template.column_name == '链接' 
				url = f
				nr.url = url.body
			end
		end
		Rails.logger.info "-------- check duplicate ------- date: #{date}, url:#{url}.\n Given fields are: #{fields}"
		# check has date and url, then procceed
		if date.nil? or url.nil?
			return nil
		end

		duplicated = NewsRelease.find(:all, :conditions=>{:classified => nr.classified, :image_date => nr.image_date, :url => nr.url})

		# find_fields = NewsReleaseField.find(:all, :conditions=>["body in (?, ?)", "#{date.body}", "#{url.body}"])

		# duplicated = []
		# find_fields.each do |ff|
		# 	r = ff.news_release
		# 	unless r.blank?
		# 		if r.classified == nr.classified
		# 			date_match = false
		# 			url_match = false
		# 			r.news_release_fields.each do |f|
		# 				if f.news_classified.template.column_name == '日期' and f.body == date.body
		# 					date_match = true
		# 				end
		# 				if f.news_classified.template.column_name == '链接' and f.body == url.body
		# 					url_match = true
		# 				end
		# 			end
		# 		end
		# 	end

		# 	if date_match && url_match
		# 		duplicated << r
		# 	end
		# end

		# return duplicated
	end
end
