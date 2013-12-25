class NewsReleaseField < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :weibo,
	:class_name => "NewsRelease",
	:foreign_key => "weibos_id"
	belongs_to :news_classified,
	:class_name => "NewsClassified",
	:foreign_key => "news_classfieds_id"
	safe_attributes 'body'

	validates_presence_of :news_release,:news_classified

	
end
