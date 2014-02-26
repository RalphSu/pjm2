#-- encoding: UTF-8
require "uri"
class ReportNotifier < ActionMailer::Base

	def _setup()
		ActionMailer::Base.delivery_method = :smtp
		ActionMailer::Base.perform_deliveries = true
		ActionMailer::Base.raise_delivery_errors = true
		ActionMailer::Base.default_content_type = "text/html"
		ActionMailer::Base.smtp_settings = {
			:address => 'smtp.163.com',
			:port => '25',
			:authentication => :login,
			:domain => 'keyi.com',
			:user_name => "ralphsu@163.com",
			:password=>"3002204184",
			:openssl_verify_mode => 'none'
		}
		host = _get_global_setting_value('mail.server.host')
		port = _get_global_setting_value('mail.server.port')
		username = _get_global_setting_value('mail.server.username')
		password = _get_global_setting_value('mail.server.password')
		if (host.blank? or port.blank? or username.blank? or password.blank?)
			return
		end

		# ActionMailer::Base.smtp_settings = {
		#     :address              => host,
		#     :port                 => port,
		#     :domain               => 'keyi.com',
		#     :user_name            => username,
		#     :password             => password,
		#     :authentication       => :login, ## or plain
		#     #:enable_starttls_auto => false
		# }
	end

	def report_notification(task,baseurl)
		# setup mailer
		_setup()

		# find out all recievers
		recips = []
		members = task.project.member_principals.find(:all, :include => [:roles, :principal]).sort
		members.each do |m|
			m.roles.each do |r|
				if (r.name == "项目管理员" or r.name == '项目审核员')
					recips << m.user.mail unless m.user.mail.blank?
					break
				end
			end
		end
		# add project client
		unless task.project.client.blank?
			task.project.client.each do |c|
				recips << c.mail unless c.mail.blank?
			end
		end

		# must have report_path
		path = task.report_path
		if path.nil?
			path = task.reviewed_path.nil? ? task.gen_path : task.reviewed_path
		end

		url = "#{baseurl}/report_task/tasks/#{task.project.identifier}/#{task.id}/download?filename=#{URI::encode(path)}"
		unless recips.blank?
			# generate mail
			subject task.project.name + ' 项目报表发布 : (' + task.report_start_time.to_s + ' ' + task.task_type.to_s + ')'
			recipients recips
			from 'no-reply@keyi.com'
			sent_on Time.now
			body  :task => task, :url=> url
			unless task.task_type == '结案报告'
				attachment :content_type=>"application/xlsx", :body=> IO.binread(File.join File.dirname(__FILE__), "../../" + path)
			end
		end
	end

	def user_create(user, baseurl)
		_setup()

		# generate mail
		subject '科翼舆情管理平台帐号创建通知'
		recipients user.mail
		from 'no-reply@keyi.com' # 
		sent_on Time.now
		body  :user=>user, :baseurl=>baseurl
	end

	def _get_global_setting_value(name)
		gs = GlobalSetting.find(:first, :conditions=>{:name => name})
		unless gs.nil?
			return gs.value
		end
	end

end
