#-- encoding: UTF-8

module NewsReleaseHelper

	def news_release_option_for_select(selected)
		## TODO : dynamiclly load from news_classified table..
		container = [[]]
		container << ['新闻稿推广', '新闻稿推广']
		container << ['平面媒体', '平面媒体']
		container << ['视频推广', '视频推广']
		container << ['视频新闻', '视频新闻']
		container <<['百度知道', '百度知道']
		options_for_select(container, selected)
	end

	def template_header(category)
		logger.info category
		fields = NewsClassified.all
		templates = []
		if category.nil?
			NewsClassified.all.each {|classified|
				logger.info classified.template
				#.cloumn_name
			}
		else 
			#fields.where("classified = #{category}").limit(100).find_by_classified(category).limit(100).collect { |classified|
			#	logger.info classified.template
				#.cloumn_name
			#}
		end 
	end
end
