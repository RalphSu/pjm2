class ContentsController < ApplicationController
  layout 'content'
  
  before_filter :find_project_by_project_id, :except => [ :index ]
  @show_project_main_menu=false

  def index
    @projects=User.current.active_projects
    @p = @projects.first unless not @project.nil?
    @category=params['category']
  end

  def project_content(project =nil)
    index
  end

  # show @project
  def show
    @category = params['category']
    @category = "" if @category.nil?
    @tab = params['tab'].nil? ? 'news' : params['tab']
    @p = Project.find(params[:project_id])
    @projects=[]
    @projects << @p unless @p.nil?
  end

end
