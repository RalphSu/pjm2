#-- encoding: UTF-8
module WeiboHelper

	def distinct_weibo_classifieds() 
		WeiboClassified.all(:select => "DISTINCT(classified)").collect do |n|
			n.classified
		end
	end

	def find_weibo_classifieds(classified)
		WeiboClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_weibo_templates()
		Template.find(:all, :conditions => {:template_type =>"微薄类模板" })
	end

end
