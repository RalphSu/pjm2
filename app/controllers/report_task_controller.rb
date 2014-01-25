class ReportTaskController < ApplicationController
  layout 'report'
  
  before_filter :find_project_by_project_id, :except => [ :index ]
  @show_project_main_menu=false

    def index
    @projects=User.current.active_projects
    unless @projects.blank?
      @project = @projects.first if @project.nil?
    end
  end


   def tasks
    @projects=User.current.active_projects

   # fill the selected flag
    @reporttasks = ReportTask.find(:all, :conditions=> {:project_id => @project.id})

    render :action => "tasks",:layout => false if request.xhr?

  end

  def create
    start_time = params[:report_start_time]
    type=params[:report_type]
    Rails.logger.info "task controller create type #{type}"
    task = ReportTask.new
    
    if type==ReportTask::TYPE_DAILY
      end_time=Time.parse(start_time).at_beginning_of_day  + 1.day
      task.report_start_time = Time.parse(start_time)
      task.report_end_time=end_time
    elsif type==ReportTask::TYPE_WEEKLY
       task.report_start_time=Time.parse(start_time).beginning_of_week()
       task.report_end_time=task.report_start_time+7.day
    elsif type==ReportTask::TYPE_SUMMARY
      task.report_start_time = Time.parse(start_time)
      task.report_end_time = Time.parse(start_time)+1.year
      
    end
   
    Rails.logger.info "task controller create start time #{task.report_start_time} end_time  #{task.report_end_time}"
    
    task.status= ReportTask::STATUS_PLANNED
    task.task_type=type
    task.gen_count= 1
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
    ## Download
    prefix = File.join File.dirname(__FILE__), "../../"
    send_file(prefix + params[:filename]) unless params[:filename].blank?  
  end

  def upload
    id = params[:task_id]
    unless id.blank?
      task = ReportTask.find(id)
      unless task.blank?
        data = params[:task_file].read
        file_name = save_reviewed_file(task, data)
        task.reviewed_path = file_name
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

  def save_reviewed_file(task, data)
    prefix = File.join File.dirname(__FILE__), "../../"
    file_name =  task.gen_path + "_reviewed.docx"
    Rails.logger.info "Save file with name #{file_name}"
    IO.binwrite(prefix + file_name, data)
    file_name
  end

  def publish
    id = params[:task_id]
    unless id.blank?
      task = ReportTask.find(id)
      unless task.blank?
        if task.status == ReportTask::STATUS_REVIEWED
          #update path and status
          task.report_path = task.reviewed_path
          if task.report_path.blank?
            task.report_path = task.gen_path
          end
          task.status=ReportTask::STATUS_PUBLISHED
          task.save!

          respond_to do |format|
            format.html {
              flash[:notice] = l(:notice_successful_publish)
              redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
            }
          end
        else
          respond_to do |format|
            format.html {
              flash[:error] = l(:notice_failed_publish)
              redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
            }
          end
        end
      end
    end
  end
end
