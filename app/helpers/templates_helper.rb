module TemplatesHelper

	def template_settings_tabs
    tabs = [
            {:name => 'info', :action => :edit_project, :partial => 'projects/edit', :label => :label_information_plural},    
           # {:name => 'members', :action => :manage_members, :partial => 'projects/settings/members', :label => :label_member_plural},
            ]
    
  end
end
