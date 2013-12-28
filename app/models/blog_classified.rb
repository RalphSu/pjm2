class BlogClassified < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :template

	safe_attributes 'classified'

	has_many :blog_fields
end
