#-- encoding: UTF-8
module ForumHelper

	def distinct_forum_classifieds() 
		ForumClassified.all(:select => "DISTINCT(classified)")

	end

	def find_forum_classifieds(classified)
		ForumClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_forum_templates()
		Template.find(:all, :conditions => {:template_type =>"论坛类模板" })
	end

	def count_forums(project, category)
		Forum.count_by_sql "SELECT COUNT(*) FROM forums n WHERE n.project_id = #{project.id} and classified = '#{category}' "
	end

	def find_forum_for_project(project, category, link, link_date)
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
		if params[:page].blank?
			page = 1
		else
			page = params[:page]
		end
		Forum.paginate(:page=>page,:per_page=>20, :order=>'image_date desc',:conditions=>conditions)

		#Forum.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'image_date asc',:conditions=>{:project_id => project, :classified => category})
	end

	def forum_option_for_select(selected)
		container = []
		container << ["", ""]
		ForumClassified.all(:select => "DISTINCT(classified)").each do |n|
			container << [n.classified, n.classified]
		end
		options_for_select(container, selected)
	end

	def find_forum_classified_hash
		# hash of hash  classified => { template_name => ForumClassified }
		map = {}
		ForumClassified.all.each  do |f|
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

	def find_field_by_forumId(forumId)
		field = ForumField.find(:all, :conditions=>{:forums_id=>forumId})
			# ,
			# :joins => "LEFT JOIN images on images.url=forum_fields.body",
			# :select => "forum_fields.*,images.file_path AS file_path ")
		if field.blank?
			map = {}
		else
			map = {}
			## check image path
			## find date column and link column
			date_field = nil
			link_field = nil
			field.each do |f|
				if f.forum_classifieds.template.column_name == "日期" and (not f.body.blank?)
					date_field = f
				elsif f.forum_classifieds.template.column_name == "链接" and (not f.body.blank?)
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
				map[f.forum_classifieds.id] = f
			end
			map
		end
		# Rails.logger.info map
		map
	end

	class ForumFactory
		def createEntity(classified_name)
			nr  = Forum.new()
			nr.classified = classified_name
			return nr
		end
		def createField(body, classified)
			field = ForumField.new()
			field.body = body
			field.forum_classifieds = classified
			return field
		end
	end

	def find_forum_duplicate(nr, fields)
		date = nil
		url = nil
		fields.each do |f|
			if f.forum_classifieds.template.column_name == '日期'
				date = f
				nr.image_date = date.body
			end
			if f.forum_classifieds.template.column_name == '链接' 
				url = f
				nr.url = url.body
			end
		end
		Rails.logger.info "-------- check duplicate ------- date: #{date}, url:#{url}.\n Given fields are: #{fields}"
		# check has date and url, then procceed
		if date.nil? or url.nil?
			return nil
		end

		duplicated = Forum.find(:all, :conditions=>{:classified => nr.classified, :image_date => nr.image_date, :url => nr.url})

		# find_fields = ForumField.find(:all, :conditions=>["body in (?, ?)", "#{date.body}", "#{url.body}"])

		# duplicated = []
		# find_fields.each do |ff|
		# 	r = ff.forums
		# 	unless r.blank?
		# 		if r.classified == nr.classified
		# 			date_match = false
		# 			url_match = false
		# 			r.forum_fields.each do |f|
		# 				if f.forum_classifieds.template.column_name == '日期' and f.body == date.body
		# 					date_match = true
		# 				end
		# 				if f.forum_classifieds.template.column_name == '链接' and f.body == url.body
		# 					url_match = true
		# 				end
		# 			end
		# 			if date_match && url_match
		# 				duplicated << r
		# 			end
		# 		end
		# 	end
		# end

		# return duplicated
	end

end
