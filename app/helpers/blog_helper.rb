#-- encoding: UTF-8
module BlogHelper


	def distinct_blog_classifieds() 
		BlogClassified.all(:select => "DISTINCT(classified)")

	end

	def find_blog_classifieds(classified)
		BlogClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_blog_templates()
		Template.find(:all, :conditions => {:template_type =>"博客类模板" })
	end

	def find_blog_for_project(project, category)
		Blog.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'updated_at desc',:conditions=>{:project_id => project, :classified => category})
	end

	def blog_option_for_select(selected)
		container = []
		container << ["", ""]
		BlogClassified.all(:select => "DISTINCT(classified)").each do |n|
			container << [n.classified, n.classified]
		end
		options_for_select(container, selected)
	end

	def find_blog_classified_hash
		# hash of hash  classified => { template_name => BlogClassified }
		map = {}
		BlogClassified.all.each  do |f|
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

	def find_field_by_blogId(blogId)
		field = BlogField.find(:all, :conditions=>{:blogs_id=>blogId})
			# ,
			# :joins => "LEFT JOIN images on images.url=blog_fields.body",
			# :select => "blog_fields.*,images.file_path AS file_path ")
		if field.blank?
			map = {}
		else
			map = {}
			## check image path
			## find date column and link column
			date_field = nil
			link_field = nil
			field.each do |f|
				if f.blog_classifieds.template.column_name == "日期"
					date_field = f
				elsif f.blog_classifieds.template.column_name == "链接"
					link_field = f
				end
			end
			# find correct _image 
			if (not date_field.blank?) and (not link_field.blank?)
				date = Date.strptime(date_field.body, "%Y-%m-%d")
				img = Image.find(:first, :conditions=> {:url => link_field.body, :image_date=> date})
				unless img.blank?
					link_field.file_path = img.file_path
				end
			end
			##
			field.each do |f|
				map[f.blog_classifieds.id] = f
			end
			map
		end
		# Rails.logger.info map
		map
	end

	class BlogFactory
		def createEntity(classified_name)
			nr  = Blog.new()
			nr.classified = classified_name
			return nr
		end
		def createField(body, classified)
			field = BlogField.new()
			field.body = body
			field.blog_classifieds = classified
			return field
		end
	end

	def find_blog_duplicate(nr, fields)
		date = nil
		url = nil
		fields.each do |f|
			if f.blog_classifieds.template.column_name == '日期'
				date = f
			end
			if f.blog_classifieds.template.column_name == '链接' 
				url = f
			end
		end
		Rails.logger.info "-------- check duplicate ------- date: #{date}, url:#{url}.\n Given fields are: #{fields}"
		# check has date and url, then procceed
		if date.nil? or url.nil?
			return nil
		end

		find_fields = BlogField.find(:all, :conditions=>["body in (?, ?)", "#{date.body}", "#{url.body}"])

		duplicated = []
		find_fields.each do |ff|
			r = ff.blogs
			unless r.blank?
				date_match = false
				url_match = false
				r.blog_fields.each do |f|
					if f.blog_classifieds.template.column_name == '日期' and f.body == date.body
						date_match = true
					end
					if f.blog_classifieds.template.column_name == '链接' and f.body == url.body
						url_match = true
					end
				end
				if date_match && url_match
					duplicated << r
				end
			end
		end

		return duplicated
	end


end
