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

end
