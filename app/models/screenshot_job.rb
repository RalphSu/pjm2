class ScreenshotJob < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :news_release, :foreign_key => "news_release_id"

end
