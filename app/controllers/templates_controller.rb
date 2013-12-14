class TemplatesController < ApplicationController
	include TemplatesHelper
	include NewsReleaseHelper
	
	layout 'admin'
	
	def index
		# classifiedName => [column_name]
		@news_field_map ={}
		news_classifieds = distinct_news_classifieds();
		news_classifieds.each do |classified|
			 @news_field_map[classified.classified] = find_new_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end
		@news_field_map

		# #blog
		# @blog_field_map ={}
		# blog_classifieds = distinct_blog_classifieds();
		# blog_classifieds.each do |classified|
		# 	 @blog_field_map[classified.classified] = find_blog_classifieds(classified.classified).collect do | c |
		# 	 	c.template.column_name
		# 	 end
		# end

		# # forum
		# @forum_field_map ={}
		# forum_classifieds = distinct_blog_classifieds();
		# forum_classifieds.each do |classified|
		# 	 @forum_field_map[classified.classified] = find_forum_classifieds(classified.classified).collect do | c |
		# 	 	c.template.column_name
		# 	 end
		# end

		# # weibo
		# @weibo_field_map ={}
		# weibo_classifieds = distinct_weibo_classifieds();
		# weibo_classifieds.each do |classified|
		# 	 @weibo_field_map[classified.classified] = find_weibo_classifieds(classified.classified).collect do | c |
		# 	 	c.template.column_name
		# 	 end
		# end
		
	end

	def view_template
		redirect_to({:controller => 'templates', :action => 'index'})
	end

end
