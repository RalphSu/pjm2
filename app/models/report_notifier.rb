#-- encoding: UTF-8
class ReportNotifier < ActionMailer::Base
  
	def report_notification(task)
		ActionMailer::Base.delivery_method = :smtp
		ActionMailer::Base.smtp_settings = {
			:address => 'smtp.163.com',
			:port => '25',
			:authentication => :login,
			:user_name => "suliangfei@163.com",
			:password=>""
		}
		@subject = "" #task.project.name + ' 项目报告发布 : (' + task.report_start_time + ' ' + task.task_type + ')',
		@recipients = ['suliangfei@gmail.com']
		@from = 'suliangfei@163.com'
		@send_on = Date.new
	end
end
