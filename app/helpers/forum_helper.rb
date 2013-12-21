module ForumHelper
	def distinct_forum_classifieds() 
		WeiboClassified.all(:select => "DISTINCT(classified)").collect do |n|
			n.classified
		end
	end
end
