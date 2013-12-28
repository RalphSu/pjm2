class BlogController < ApplicationController	
	include BlogHelper
	include ContentsHelper
	layout 'content'

	before_filter :find_project_by_project_id
	
	@show_project_main_menu=false

	verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed }
	def create
		init(params)

		data = params['record'].read
		file_name = save_tmp_file(data)

		headers = _get_header()
		data =  IO.binread(file_name)
		Rails.logger.info "read record size: #{data.size}"
		poiReader = PoiExcelReader.new(_get_classified_hash, _get_factory)
	  	uploadItems = poiReader.read_excel_text(file_name, headers)

	  	save(uploadItems)

	  	remove_tmp_file(file_name)
	  	redirect_to({:controller => 'blog', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def _get_factory
		BlogFactory.new()
	end

	def _get_classified_hash
		find_blog_classified_hash()
	end
	def _get_header
		distinct_blog_templates()
	end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			# save the entity line first
			ai.entity.project = @project
			ai.entity.save
			Rails.logger.info "a activity line is saved: #{ai.entity}"
			# now the fields
			ai.items.each do |item|
				Rails.logger.info item.blog_classifieds.id
				item.blogs = ai.entity
				Rails.logger.info item.blogs.id
				item.save
			end
		end
	end

	def edit_blog
		init(params)
		redirect_to({:controller => 'blog', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def destory_blog
		init(params)
		redirect_to({:controller => 'blog', :action => 'index', :category=>@category, :project_id=>@project.identifier})
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
