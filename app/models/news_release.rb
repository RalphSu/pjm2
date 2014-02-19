class NewsRelease < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified', 'image_date', 'url'

	has_many :news_release_fields, :foreign_key=>"news_releases_id", :dependent => :delete_all

	belongs_to :crawler_job, :class_name => "CrawlerJob",
	:foreign_key => "crawler_id"

end
