class NewsReleaseField < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :news_release
	belongs_to :news_classified

	safe_attributes 'body'

	attr_accessor :column_name

	@column_name
end
