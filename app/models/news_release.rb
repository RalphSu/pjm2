class NewsRelease < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified'

	has_many :news_release_fields

	belongs_to :crawler_job, :class_name => "CrawlerJob",
	:foreign_key => "crawler_id"

end
