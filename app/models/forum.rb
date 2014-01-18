class Forum < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified'

	has_many :forum_fields, :foreign_key => "forums_id"
end
