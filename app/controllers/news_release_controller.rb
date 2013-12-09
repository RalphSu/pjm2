#--encoding=UTF-8
class NewsReleaseController < ApplicationController
	layout 'content'

	before_filter :find_project_by_project_id
	
	@show_project_main_menu=false

	def teplate_type
		'新闻类模板'
	end

	def new
		init(params)
	end

	verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed }
	def create
		init(params)
		if @category.blank?
			# category must be present
    		@message = l(:error_no_cateory)
		    respond_to do |format|
		      format.html {
		        render :template => 'common/error', :layout => use_layout, :status => 400
		      }
		  	end
		  	return
		end

		data = params['record'].read
	  	uploadItems = deserializeCSV(data)
	  	save(uploadItems)

	  	redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def save(activeItems)
		activeItems.each do |ai|
			# save the item first
			ai.entity.safe_attributes = {:classified => @category}
			ai.entity.project = @project # would it be saved??
			ai.entity.save
			# now the fields
			ai.items.each do |item|
				template_ids = []
				Template.where(:column_name=>item.column_name).each do |t|
					ids << t.id
				end

				n = NewsClassified::where(:template_id => template_ids, :classified=>@category)
				unless n.blank?
					item.news_classfied = n
					item.news_release = ai.entity
					item.save
				end
			end
		end
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

