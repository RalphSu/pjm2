class ContentsController < ApplicationController

  before_filter :find_project_by_project_id, :except => [ :index ]
  @show_project_main_menu=false

  def index
  	## TODO: get current users' projects
  	@projects = Project.all
     @p = @projects.first unless not @project.nil?
     @category=params['category']
  end

  def project_content(project =nil)

  end

  # show @project
  def show
    @category=params['category']
    @p = Project.find(params[:project_id])
    @projects=[]
    @projects << @p unless @p.nil?
  end

end
