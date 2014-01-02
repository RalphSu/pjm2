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

	def find_forum_for_project(project, category)
		Forum.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'updated_at desc',:conditions=>{:project_id => project, :classified => category})
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

	def find_field_by_forumId(weiboId)
		field = ForumField.find(:all, :conditions=>{:forums_id=>weiboId})
		if field.blank?
			map = {}
		else
			map = {}
			field.each do |f|
				map[f.forum_classifieds.id] = f.body
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

end
