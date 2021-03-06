class NewsReleaseField < ActiveRecord::Base
	include Redmine::SafeAttributes

 	attr_accessor 'file_path'

	belongs_to :news_release,
	:class_name => "NewsRelease",
	:foreign_key => "news_releases_id"
	belongs_to :news_classified,
	:class_name => "NewsClassified",
	:foreign_key => "news_classifieds_id"
	safe_attributes 'body'

	validates_presence_of :news_release,:news_classified

	
end
