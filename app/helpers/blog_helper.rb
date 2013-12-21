module BlogHelper
	def distinct_blog_classifieds() 
		BlogClassified.all(:select => "DISTINCT(classified)").collect do |n|
			n.classified
		end
	end
end
