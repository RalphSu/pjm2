class TemplatesController < ApplicationController
	include TemplatesHelper

	
	layout 'admin'
	
	def index
		## TODO: fix to get projects based on current user
		@projects = Project.all
	end

end
