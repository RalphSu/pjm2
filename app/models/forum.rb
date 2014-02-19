class Forum < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified', 'image_date', 'url'

	has_many :forum_fields, :foreign_key => "forums_id", :dependent => :delete_all
end
