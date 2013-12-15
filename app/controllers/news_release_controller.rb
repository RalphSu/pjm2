class NewsReleaseController < ApplicationController
	layout 'content'

	before_filter :find_project_by_project_id
	
	@show_project_main_menu=false

	def new
		init(params)
	end

	verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed }
	def create
		init(params)
	   	name =  params['record'].original_filename
	  	directory = "public/"
	  	# create the file path
	  	path = File.join(directory, name)
	  	# write the file
	  	File.open(path, "wb") { |f| f.write(params['record'].read) }

	  	##redirect_to url_for(controller: 'news_release', action: 'create')
	end

	def index
		init(params)
	end


	def init(params)
		@category=params[:category]
		@p = @project
		@projects =[]
		@projects << @p unless @p.nil?
	end
end

