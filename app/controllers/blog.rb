class Blog < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified', 'image_date', 'url'

	has_many :blog_fields,  :foreign_key => "blogs_id", :dependent => :delete_all
end