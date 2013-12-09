#-- encoding: UTF-8

module NewsReleaseHelper
	def news_release_option_for_select(selected)
		container = [[]]
		container << ['新闻稿推广', '新闻稿推广']
		container << ['平面媒体', '平面媒体']
		container << ['视频推广', '视频推广']
		container << ['视频新闻', '视频新闻']
		container <<['百度知道', '百度知道']
		options_for_select(container, selected)
	end
end
