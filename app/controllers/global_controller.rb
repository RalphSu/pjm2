#-- encoding: UTF-8
class GlobalController < ApplicationController
	layout 'admin'

  	before_filter :require_admin

	def index
		@host = _get_global_setting_value('mail.server.host')
		@port = _get_global_setting_value('mail.server.port')
		@username = _get_global_setting_value('mail.server.username')
		@domain = _get_global_setting_value('mail.server.domain')
		@ssl = _get_global_setting_value('mail.server.ssl')
		@password = _get_global_setting_value('mail.server.password')
	end

	def update_mail
		# mail server host
		_upsert_global_setting('mail.server.host', params['host'])

		# mail server port
		_upsert_global_setting('mail.server.port', params['port'])

		_upsert_global_setting('mail.server.domain', params['domain'])

		_upsert_global_setting('mail.server.ssl', params['ssl'])

		# mail server username
		_upsert_global_setting('mail.server.username', params['username'])

		# mail server password
		# encrypted
		_upsert_global_setting('mail.server.password', params['password'])

		flash[:notice] = l(:notice_successful_update)
		redirect_to({:controller => 'global', :action => 'index'})
	end

	def test_mail
		# send out a test mail
		msg = ""
		username = _get_global_setting_value('mail.server.username')
		begin
			ReportNotifier.deliver_test()
			msg = "邮件发送成功，请#{username}查收!"
		rescue Exception => e
			msg = "邮件发送失败。请注意正确设置邮件服务器信息，并确认保存。发送失败原因是 #{e.message}!"
			Rails.logger.info msg
		end
		flash[:notice] = msg
		redirect_to({:controller => 'global', :action => 'index'})
	end

	def _get_global_setting_value(name)
		gs = GlobalSetting.find(:first, :conditions=>{:name => name})
		unless gs.nil?
			return gs.value
		end
	end

	def _upsert_global_setting(name, value)
		oldSetting = GlobalSetting.find(:first, :conditions=>{:name => name})
		if oldSetting.nil?
			Rails.logger.info "Create setting #{name} with value #{value}!"
			gs = GlobalSetting.new
			gs.name = name
			gs.value = value
			gs.save!
		else
			Rails.logger.info "Change setting #{oldSetting.name} from #{oldSetting.value} to #{value}!"
			oldSetting.value = value
			oldSetting.save!
		end
	end

end
