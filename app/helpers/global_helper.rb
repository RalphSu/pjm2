module GlobalHelper

	def global_settings_tabs
	tabs = [
		{:name => 'mailer', :action => :mail, :partial => 'global/mail_setting', :label => :label_mail_setting}
		]
	end
end
