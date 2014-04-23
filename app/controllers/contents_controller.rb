class ContentsController < ApplicationController
  layout 'content'
  
  before_filter :find_project_by_project_id, :except => [ :index ]
  @show_project_main_menu=false

  def index
    if User.current.employee?
      @projects=User.current.active_projects
    else 
      @projects=User.current.active_client_projects
    end
    @p = @projects.first unless not @project.nil?
    @project = @p
    @category=params['category']

    Rails.logger.info "===========================================================#{request.protocol}#{request.host}:#{request.port}"
  end

  def project_content(project =nil)
    index
  end

  # show @project
  def show
    @category = params['category']
    @category = "" if @category.nil?
    @link = params[:link]
    @link_date = params[:link_date]
    @tab = params['tab'].nil? ? 'news' : params['tab']
    @p = Project.find(params[:project_id])
    @project = @p
    @projects=[]
    @projects << @p unless @p.nil?
  end

end
