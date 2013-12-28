class ForumField < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :forums, :class_name => "Forum", :foreign_key => "forums_id"
	belongs_to :forum_classifieds, :class_name => "ForumClassified", :foreign_key => "forum_classfieds_id"
	safe_attributes 'body'

	validates_presence_of :forums, :forum_classifieds

end
