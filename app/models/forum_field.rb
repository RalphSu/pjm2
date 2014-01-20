class ForumField < ActiveRecord::Base
	include Redmine::SafeAttributes
	attr_accessor 'file_path'

	belongs_to :forums, :class_name => "Forum", :foreign_key => "forums_id"
	belongs_to :forum_classifieds, :class_name => "ForumClassified", :foreign_key => "forum_classifieds_id"
	safe_attributes 'body'

	validates_presence_of :forums, :forum_classifieds

end
