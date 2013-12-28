class ForumClassified < ActiveRecord::Base

  	include Redmine::SafeAttributes

	belongs_to :template

	safe_attributes 'classified'

	has_many :forum_fields
end
