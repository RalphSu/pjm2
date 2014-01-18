class Blog < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified'

	has_many :blog_fields,  :foreign_key => "blogs_id"
end