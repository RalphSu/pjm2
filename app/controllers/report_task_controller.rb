class ReportTaskController < ApplicationController
  layout 'report'
  
  before_filter :find_project_by_project_id, :except => [ :index ]
  @show_project_main_menu=false

    def index
  	## TODO: get current users' projects
    @projects=Project.all
  	# allprojects = Project.all
   #  @projects=[]
   #      allprojects.each do |aa|
   #        if User.current.allowed_to?('index', aa)
   #          projects<<aa
   #        end
   #      end
    @p = @projects.first unless not @project.nil?
  end


   def tasks
   
   # fill the selected flag
    @reporttasks = ReportTask.find(:all, :conditions=> {:project_id => @project.id})

    render :action => "tasks",:layout => false if request.xhr?

  end

end
