class NewsReleaseField < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :news_release, :dependent => :destory
	belongs_to :news_classified, :dependent => :destory

	safe_attributes 'body'

	attr_accessor :column_name

	@column_name
end
