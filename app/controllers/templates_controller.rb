class TemplatesController < ApplicationController
	include TemplatesHelper
	include NewsReleaseHelper
	
	layout 'admin'
	
	def index
		## TODO: fix to get projects based on current user
		@groupClassifieds ={}
		classifiedsNames= distinct_news_classifieds();
		classifiedsNames.each do |classifiedsName|
			 @groupClassifieds[classifiedsName] = find_new_classifieds(classifiedsName)
		end
		@groupClassifieds
	end

	def view_template
		redirect_to({:controller => 'templates', :action => 'index'})
	end

end
