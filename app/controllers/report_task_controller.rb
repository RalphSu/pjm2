#-- encoding: UTF-8
class ReportTaskController < ApplicationController
  layout 'report'
  include ContentsHelper
  before_filter :find_project_by_project_id, :except => [ :index ]
  @show_project_main_menu=false

    def index

    if User.current.employee?
      @projects=User.current.active_projects
    else 
      @projects=User.current.active_client_projects
    end
    unless @projects.blank?
      @project = @projects.first if @project.nil?
    end
  end


   def tasks
     if User.current.employee?
        @projects=User.current.active_projects
         # fill the selected flag
          if User.current.admin?
            @reporttasks = ReportTask.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'updated_at desc', :conditions=> {:project_id => @project.id})
          else
            @reporttasks = ReportTask.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'updated_at desc', :conditions=> ["project_id = ? AND status<> ? ", @project.id, ReportTask::STATUS_CANCELPUBLISH])
          end
      else 
      @projects=User.current.active_client_projects
      @reporttasks = ReportTask.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'updated_at desc', :conditions=> {:project_id => @project.id,:status=>ReportTask::STATUS_PUBLISHED})
    end

    render :action => "tasks",:layout => false if request.xhr?

  end

  def create
    start_time = params[:report_start_time]
    end_time=params[:report_end_time]
    type=params[:report_type]
    Rails.logger.info "task controller create type #{type}"
    task = ReportTask.new
    
    if type==ReportTask::TYPE_DAILY
      end_time=Time.parse(start_time).at_beginning_of_day  + 1.day
      task.report_start_time = Time.parse(start_time)
      task.report_end_time=end_time
      _save_news_event("新增日报任务", "新增日报任务","新增日报任务")
    elsif type==ReportTask::TYPE_WEEKLY
       task.report_start_time=Time.parse(start_time)
        if end_time.blank?
          task.report_end_time=task.report_start_time+7.day
        elsif 
          task.report_end_time=Time.parse(end_time)
        end
          
       _save_news_event("新增周报任务", "新增周报任务","新增周报任务")
    elsif type==ReportTask::TYPE_SUMMARY
      task.report_start_time = Time.parse(start_time)
      task.report_end_time = Time.parse(start_time)+1.year
      _save_news_event("新增结案报告任务", "新增结案报告任务","新增结案报告任务")
      
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
    _save_news_event("下载文件"+params[:filename], "下载文件"+params[:filename],"下载文件"+params[:filename])
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
        _save_news_event("上传审核报表文件", "上传审核报表文件","上传审核报表文件")
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
          _save_news_event("发布报表", "发布报表","发布报表")

          notification_msg = _send_mail_notification(task, request)

          respond_to do |format|
            format.html {
              flash[:notice] = l(:notice_successful_publish) + notification_msg
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

  def _send_mail_notification(task, request)

    # find out all recievers
    users = []
    members = task.project.member_principals.find(:all, :include => [:roles, :principal]).sort
    members.each do |m|
      m.roles.each do |r|
        if (r.name == "项目管理员" or r.name == '项目审核员')
          users << m.user unless m.user.mail.blank?
          break
        end
      end
    end
    # add project client
    unless task.project.client.blank?
      task.project.client.each do |c|
        users << c unless c.mail.blank?
      end
    end

    notification_msg = '发送邮件'
    begin
      users.each do |u|
        if (task.task_type == '结案报告')
          ReportNotifier.deliver_summary_report(task, u, "#{request.protocol}#{request.host}:#{request.port}")
        else
          ReportNotifier.deliver_report_notification(task, u, "#{request.protocol}#{request.host}:#{request.port}")
        end
      end
      _save_news_event("报表发布邮件通知", "报表发布邮件通知","报表发布邮件通知")
      notification_msg = '报表发布邮件通知已发送!'
    rescue Exception => e
      Rails.logger.info " sending publish notification failed. Exception is #{e.message}"
      notification_msg = '报表发布邮件通知未发送成功，请注意设置正确的邮件服务器！'
    end
    Rails.logger.info "===============#{notification_msg}"

    return notification_msg
  end


  def unpublish
    id = params[:task_id]
    unless id.blank?
      task = ReportTask.find(id)
      unless task.blank?
        if task.status == ReportTask::STATUS_PUBLISHED
          task.status=ReportTask::STATUS_CANCELPUBLISH
          task.save!
          _save_news_event("取消发布报表", "取消发布报表","取消发布报表")
          respond_to do |format|
            format.html {
              flash[:notice] = l(:notice_successful_unpublish)
              redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
            }
          end
        else
          respond_to do |format|
            format.html {
              flash[:error] = l(:notice_failed_unpublish)
              redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
            }
          end
        end
      end
    end
  end

  def republish
    id = params[:task_id]
    unless id.blank?
      task = ReportTask.find(id)
      unless task.blank?
        if task.status == ReportTask::STATUS_CANCELPUBLISH
             #update path and status
          task.report_path = task.reviewed_path
          if task.report_path.blank?
            task.report_path = task.gen_path
          end
          task.status=ReportTask::STATUS_PUBLISHED
          task.save!
          _save_news_event("重新发布报表", "重新发布报表","重新发布报表")
          notification_msg = _send_mail_notification(task, request)
          respond_to do |format|
            format.html {
              flash[:notice] = l(:notice_successful_republish)  + notification_msg
              redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
            }
          end
        else
          respond_to do |format|
            format.html {
              flash[:error] = l(:notice_failed_republish) + notification_msg
              redirect_to({:controller => 'report_task', :action => 'tasks', :project_id=>@project.identifier})
            }
          end
        end
      end
    end
  end
end
