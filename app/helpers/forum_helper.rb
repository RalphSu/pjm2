module ForumHelper

	def distinct_forum_classifieds() 
		ForumClassified.all(:select => "DISTINCT(classified)").collect do |n|
			n.classified
		end
	end

	def find_forum_classifieds(classified)
		ForumClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_forum_templates()
		Template.find(:all, :conditions => {:template_type =>"论坛类模板" })
	end

end
