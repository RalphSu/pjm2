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

	def find_field_by_blogId(weiboId)
		field = BlogField.find(:all, :conditions=>{:blogs_id=>weiboId})
		if field.blank?
			map = {}
		else
			map = {}
			field.each do |f|
				map[f.blog_classifieds.id] = f.body
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

end
