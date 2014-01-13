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
    @project = @projects.first unless not @project.nil?
  end


   def tasks
    ## TODO: get current users' projects
    @projects=Project.all

   # fill the selected flag
    @reporttasks = ReportTask.find(:all, :conditions=> {:project_id => @project.id})

    render :action => "tasks",:layout => false if request.xhr?

  end

  def create
    start_time = params[:report_start_time]
    end_time = params[:report_end_time]
    task = ReportTask.new
    task.status= ReportTask::STATUS_PLANNED
    task.gen_count= 1
    unless start_time.blank?
          task.report_start_time = Time.parse(start_time)
    end
    unless end_time.blank?
           task.report_end_time = Time.parse(end_time)
    end
    task.project = @project
    task.save!

    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_create)
        redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
      }
    end
  end

  def download
    
  end

  def upload
    id = params[:task_id]
    unless id.blank?
      task = ReportTask.find(id)
      unless task.blank?

        ## TODO : saved

        task.status=ReportTask::STATUS_REVIEWED
        task.save!
      end
    end
    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_upload)
        redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
      }
    end
  end

  def publish
    id = params[:task_id]
    unless id.blank?
      task = ReportTask.find(id)
      unless task.blank?
        task.status=ReportTask::STATUS_PUBLISHED
        task.save!
      end
    end
    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_publish)
        redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
      }
    end
  end

end
