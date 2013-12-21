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

	def find_new_classifieds(classified)
		# select * from news_classified where classified = '@@@'
		NewsClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_news_classifieds() 
		NewsClassified.all(:select => "DISTINCT(classified)").collect do |n|
			n.classified
		end
	end

end
