class BlogField < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :blogs, :class_name => "Blog", :foreign_key => "blogs_id"
	belongs_to :blog_classifieds, :class_name => "BlogClassified", :foreign_key => "blog_classfieds_id"
	safe_attributes 'body'

	validates_presence_of :blogs, :blog_classifieds

end
