class NewsRelease < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified'

	has_many :news_release_field

end
