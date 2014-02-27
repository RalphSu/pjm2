#-- encoding: UTF-8
require "uri"
class ReportNotifier < ActionMailer::Base

	def _setup()
		ActionMailer::Base.delivery_method = :smtp
		ActionMailer::Base.perform_deliveries = true
		ActionMailer::Base.raise_delivery_errors = true
		ActionMailer::Base.default_content_type = "text/html"
		# ActionMailer::Base.smtp_settings = {
		# 	:address => 'smtp.163.com',
		# 	:port => '25',
		# 	:authentication => :login,
		# 	:domain => 'keyi.com',
		# 	:user_name => "ralphsu@163.com",
		# 	:password=>"3002204184",
		# 	:openssl_verify_mode => 'none'
		# }
		host = _get_global_setting_value('mail.server.host')
		port = _get_global_setting_value('mail.server.port')
		username = _get_global_setting_value('mail.server.username')
		domain = _get_global_setting_value('mail.server.domain')
		ssl = _get_global_setting_value('mail.server.ssl')
		password = _get_global_setting_value('mail.server.password')
		if (host.blank? or port.blank? or username.blank? or password.blank?)
			return
		end

		ssl = ssl == 'ssl'
		ActionMailer::Base.smtp_settings = {
		    :address              => host,
		    :port                 => port,
		    :domain               => domain,
		    :user_name            => username,
		    :password             => password,
		    :authentication       => :login, ## or plain
		    :enable_starttls_auto => ssl
		}
		Rails.logger.info "  mail server setting are #{ActionMailer::Base.smtp_settings} !"
	end

	# normal report notification, with attachment.
	def report_notification(task,user, baseurl)
		# setup mailer
		username = _get_global_setting_value('mail.server.username')
		_setup()

		Rails.logger.info "send mail to #{user.mail}"

		# must have report_path
		path = task.report_path
		if path.nil?
			path = task.reviewed_path.nil? ? task.gen_path : task.reviewed_path
		end

		url = "#{baseurl}/report_task/tasks/#{task.project.identifier}/#{task.id}/download?filename=#{URI::encode(path)}"
		unless user.mail.blank?
			type = ''
			unless task.task_type.blank?
				type = ReportTask::TYPE_LABEL[task.task_type]
			end
			content_type "multipart/alternative"
			# generate mail
			report_date = task.report_start_time.strftime('%Y年%m月%d日')
			subject task.project.name + ' 项目报表发布 : ( ' + report_date.to_s + ' ' + type + ' )'
			recipients user.mail
			from username
			sent_on Time.now
			date = Time.now
			date = date.strftime('%Y年%m月%d日')
			part  :content_type => 'text/html', :body => render_message('report_notification', {:task => task, :url=> url, :user=>user, :date=>date, :type=>type})

			filename = task.project.name + report_date.to_s + ' ' + type + ".docx"
			attachment :filename=> filename, :content_type=>"application/msword", :body=> IO.binread(File.join File.dirname(__FILE__), "../../" + path)
		end
	end

	def summary_report(task, user, baseurl)
		username = _get_global_setting_value('mail.server.username')
		_setup()

		Rails.logger.info "send mail to #{user.mail}"

		path = task.report_path
		if path.nil?
			path = task.reviewed_path.nil? ? task.gen_path : task.reviewed_path
		end

		url = "#{baseurl}/report_task/tasks/#{task.project.identifier}/#{task.id}/download?filename=#{URI::encode(path)}"
		unless user.mail.blank?
			# generate mail
			subject task.project.name + ' 项目报表发布 : ( 结案报告 )'
			recipients user.mail
			from username
			sent_on Time.now
			date = Time.now
			date = date.strftime('%Y年%m月%d日')
			body  :task => task, :url=> url, :user=>user, :date=>date
		end
	end

	def user_create(user, baseurl)
		username = _get_global_setting_value('mail.server.username')
		_setup()

		Rails.logger.info "send mail to #{user.mail}"

		# generate mail
		subject '科翼舆情管理平台帐号创建通知'
		recipients user.mail
		from username # 
		sent_on Time.now
		date = Time.now
		date = date.strftime('%Y年%m月%d日')
		body  :user=>user, :baseurl=>baseurl, :date=>date
	end

	def _get_global_setting_value(name)
		gs = GlobalSetting.find(:first, :conditions=>{:name => name})
		unless gs.nil?
			return gs.value
		end
	end

	def test()
		username = _get_global_setting_value('mail.server.username')
		_setup()

		# generate mail
		subject '科翼舆情管理平台测试邮件'
		recipients username
		from username # 
		sent_on Time.now
		date = Time.now
		date = date.strftime('%Y年%m月%d日')
		body  :username => username
	end

end
