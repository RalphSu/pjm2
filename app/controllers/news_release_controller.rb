class NewsReleaseController < ApplicationController
	layout 'content'

	before_filter :find_project_by_project_id
	
	@show_project_main_menu=false

	def new
		id = params[:project_id]
	end

	def index
		@p = @project
		@projects =[]
		@projects << @p unless @p.nil?
	end
end

