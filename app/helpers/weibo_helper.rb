module WeiboHelper
	def distinct_weibo_classifieds() 
		WeiboClassified.all(:select => "DISTINCT(classified)").collect do |n|
			n.classified
		end
	end
end
