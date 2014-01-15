  #-- encoding: UTF-8
#-- copyright
# ChiliProject is a project management system.
#
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'redmine/access_control'
require 'redmine/menu_manager'
require 'redmine/activity'
require 'redmine/search'
require 'redmine/custom_field_format'
require 'redmine/mime_type'
require 'redmine/core_ext'
require 'redmine/themes'
require 'redmine/hook'
require 'redmine/plugin'
require 'redmine/notifiable'
require 'redmine/wiki_formatting'
require 'redmine/scm/base'

begin
  require_library_or_gem 'RMagick' unless Object.const_defined?(:Magick)
rescue LoadError
  # RMagick is not available
end

if RUBY_VERSION < '1.9'
  require 'faster_csv'
else
  require 'csv'
  FCSV = CSV
end

Redmine::Scm::Base.add "Subversion"
Redmine::Scm::Base.add "Darcs"
Redmine::Scm::Base.add "Mercurial"
Redmine::Scm::Base.add "Cvs"
Redmine::Scm::Base.add "Bazaar"
Redmine::Scm::Base.add "Git"
Redmine::Scm::Base.add "Filesystem"

Redmine::CustomFieldFormat.map do |fields|
  fields.register Redmine::CustomFieldFormat.new('string', :label => :label_string, :order => 1)
  fields.register Redmine::CustomFieldFormat.new('text', :label => :label_text, :order => 2)
  fields.register Redmine::CustomFieldFormat.new('int', :label => :label_integer, :order => 3)
  fields.register Redmine::CustomFieldFormat.new('float', :label => :label_float, :order => 4)
  fields.register Redmine::CustomFieldFormat.new('list', :label => :label_list, :order => 5)
  fields.register Redmine::CustomFieldFormat.new('date', :label => :label_date, :order => 6)
  fields.register Redmine::CustomFieldFormat.new('bool', :label => :label_boolean, :order => 7)
  fields.register Redmine::CustomFieldFormat.new('user', :label => :label_user, :only => %w(Issue TimeEntry Version Project), :edit_as => 'list', :order => 8)
  fields.register Redmine::CustomFieldFormat.new('version', :label => :label_version, :only => %w(Issue TimeEntry Version Project), :edit_as => 'list', :order => 9)
end

# Permissions
Redmine::AccessControl.map do |map|
  map.permission :view_project, {:projects => [:show], :activities => [:index]}, :require=>:member
  map.permission :search_project, {:search => :index}, :public => true
  map.permission :add_project, {:projects => [:new, :create]}, :require => :loggedin
  map.permission :edit_project, {:projects => [:settings, :edit, :update]}, :require => :member
  map.permission :select_project_modules, {:projects => :modules}, :require => :member
  map.permission :manage_members, {:projects => :settings, :members => [:new, :edit, :destroy, :autocomplete_for_member]}, :require => :member
  map.permission :manage_versions, {:projects => :settings, :versions => [:new, :create, :edit, :update, :close_completed, :destroy]}, :require => :member
  map.permission :add_subprojects, {:projects => [:new, :create]}, :require => :member
  # report
  map.permission :report_index, {:report_template => [:index, :show]}
  # content
  map.permission :view_content, {:contents => [:index, :show, :project_content]}
  map.permission :update_news_release, {:contents => [:index, :show, :project_content],
                                                                                        :news_release => [:create, :edit_release, :delete_release]}
  map.permission :update_weibo, {:contents => [:index, :show, :project_content],
                                                                      :weibo=> [:index, :edit_weibo, :destory_weibo]}
  map.permission :update_blog,  {:contents => [:index, :show, :project_content],
                                                                      :blog=> [:index, :edit_blog, :destory_blog]}
  map.permission :update_forum, {:contents => [:index, :show, :project_content],
                                                                      :forum=> [:index, :edit_blog, :destory_forum]}
  map.permission :manager_permission, {
     :contents => [:index, :show, :project_content],
     :news_release => [:create, :edit_release, :delete_release],
     :weibo=> [:index, :edit_weibo, :destory_weibo],
     :weixin=> [:index, :edit_weixin, :destory_weixin],
     :summary=> [:index, :edit_summary, :destory_summary],
     :blog=> [:index, :edit_blog, :destory_blog],
     :forum=> [:index, :edit_blog, :destory_forum],
     :projects => [:index, :show, :settings, :edit, :update, :modules, :new, :create, :edit_project, :manage_members, :report_index],
     :forum=> [:index, :edit_blog, :destory_forum],
     :report_task=>[:index, :tasks, :create,:download, :upload, :publish],
     :report_template=>[:save]
  }, :require => :member

  map.permission :reviwer_permission, {
    :projects => [:index, :show],
    :report_task=>[:index, :tasks, :create,:download, :upload, :publish],
    :report_template=>[:save]
  }, :require => :member


  map.project_module :issue_tracking do |map|
    # Issue categories
    map.permission :manage_categories, {:projects => :settings, :issue_categories => [:new, :edit, :destroy]}, :require => :member
    # Issues
    map.permission :view_issues, {:issues => [:index, :show],
                                  :auto_complete => [:issues],
                                  :context_menus => [:issues],
                                  :versions => [:index, :show, :status_by],
                                  :journals => [:index, :diff],
                                  :queries => :index,
                                  :reports => [:issue_report, :issue_report_details]}
    map.permission :add_issues, {:issues => [:new, :create, :update_form]}
    map.permission :edit_issues, {:issues => [:edit, :update, :bulk_edit, :bulk_update, :update_form], :journals => [:new]}
    map.permission :manage_issue_relations, {:issue_relations => [:new, :destroy]}
    map.permission :manage_subtasks, {}
    map.permission :add_issue_notes, {:issues => [:edit, :update], :journals => [:new]}
    map.permission :edit_issue_notes, {:journals => :edit}, :require => :loggedin
    map.permission :edit_own_issue_notes, {:journals => :edit}, :require => :loggedin
    map.permission :move_issues, {:issue_moves => [:new, :create]}, :require => :loggedin
    map.permission :delete_issues, {:issues => :destroy}, :require => :member
    # Queries
    map.permission :manage_public_queries, {:queries => [:new, :edit, :destroy]}, :require => :member
    map.permission :save_queries, {:queries => [:new, :edit, :destroy]}, :require => :loggedin
    # Watchers
    map.permission :view_issue_watchers, {}
    map.permission :add_issue_watchers, {:watchers => :new}
    map.permission :delete_issue_watchers, {:watchers => :destroy}
  end

  map.project_module :time_tracking do |map|
    map.permission :log_time, {:timelog => [:new, :create]}, :require => :loggedin
    map.permission :view_time_entries, :timelog => [:index, :show], :time_entry_reports => [:report]
    map.permission :edit_time_entries, {:timelog => [:edit, :update, :destroy]}, :require => :member
    map.permission :edit_own_time_entries, {:timelog => [:edit, :update, :destroy]}, :require => :loggedin
    map.permission :manage_project_activities, {:project_enumerations => [:update, :destroy]}, :require => :member
  end

  map.project_module :news do |map|
    map.permission :manage_news, {:news => [:new, :create, :edit, :update, :destroy], :comments => [:destroy]}, :require => :member
    map.permission :view_news, {:news => [:index, :show]}, :require=>:member
    map.permission :comment_news, {:comments => :create}
  end

  map.project_module :documents do |map|
    map.permission :manage_documents, {:documents => [:new, :edit, :destroy, :add_attachment]}, :require => :loggedin
    map.permission :view_documents, :documents => [:index, :show, :download]
    map.permission :view_document_watchers, {}
    map.permission :add_document_watchers, {:watchers => :new}
    map.permission :delete_document_watchers, {:watchers => :destroy}
  end

  map.project_module :files do |map|
    map.permission :manage_files, {:files => [:new, :create]}, :require => :loggedin
    map.permission :view_files, :files => :index, :versions => :download
  end

  map.project_module :wiki do |map|
    map.permission :manage_wiki, {:wikis => [:edit, :destroy]}, :require => :member
    map.permission :rename_wiki_pages, {:wiki => :rename}, :require => :member
    map.permission :delete_wiki_pages, {:wiki => :destroy}, :require => :member
    map.permission :view_wiki_pages, :wiki => [:index, :show, :special, :date_index]
    map.permission :export_wiki_pages, :wiki => [:export]
    map.permission :view_wiki_edits, :wiki => [:history, :diff, :annotate]
    map.permission :edit_wiki_pages, :wiki => [:edit, :update, :preview, :add_attachment]
    map.permission :delete_wiki_pages_attachments, {}
    map.permission :protect_wiki_pages, {:wiki => :protect}, :require => :member
    map.permission :view_wiki_page_watchers, {}
    map.permission :add_wiki_page_watchers, {:watchers => :new}
    map.permission :delete_wiki_page_watchers, {:watchers => :destroy}
  end

  map.project_module :repository do |map|
    map.permission :manage_repository, {:repositories => [:edit, :committers, :destroy]}, :require => :member
    map.permission :browse_repository, :repositories => [:show, :browse, :entry, :annotate, :changes, :diff, :stats, :graph]
    map.permission :view_changesets, :repositories => [:show, :revisions, :revision]
    map.permission :commit_access, {}
  end

  map.project_module :boards do |map|
    map.permission :manage_boards, {:boards => [:new, :edit, :destroy]}, :require => :member
    map.permission :view_messages, {:boards => [:index, :show], :messages => [:show]}, :public => true
    map.permission :add_messages, {:messages => [:new, :reply, :quote]}
    map.permission :edit_messages, {:messages => :edit}, :require => :member
    map.permission :edit_own_messages, {:messages => :edit}, :require => :loggedin
    map.permission :delete_messages, {:messages => :destroy}, :require => :member
    map.permission :delete_own_messages, {:messages => :destroy}, :require => :loggedin
    map.permission :view_board_watchers, {}
    map.permission :add_board_watchers, {:watchers => :new}
    map.permission :delete_board_watchers, {:watchers => :destroy}

    map.permission :view_message_watchers, {}
    map.permission :add_message_watchers, {:watchers => :new}
    map.permission :delete_message_watchers, {:watchers => :destroy}

  end

  map.project_module :calendar do |map|
    map.permission :view_calendar, :calendars => [:show, :update]
  end

  map.project_module :gantt do |map|
    map.permission :view_gantt, :gantts => [:show, :update]
  end
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.push :welcome, { :controller => 'welcome', :action => 'index' }, :if => Proc.new { User.current.logged? }
  menu.push :contents, { :controller => 'contents', :action => 'index' }, :caption => :label_my_projects
  menu.push :report , { :controller => 'report_task', :action => 'index' },:caption=>:label_report_analyse
  menu.push :pjconfig, { :controller => 'pjconfig', :action => 'index' }, :if => Proc.new { !User.current.admin? }
  menu.push :admin, { :controller => 'admin', :action => 'index' }, :if => Proc.new { User.current.admin? }, :last => true
  
  # remove help in top-menu
  # menu.push :help, Redmine::Info.help_url, :last => true, :caption => "?"
end

Redmine::MenuManager.map :account_menu do |menu|
  menu.push :my_account, { :controller => 'my', :action => 'account' }, :if => Proc.new { User.current.logged? }
  menu.push :logout, :signout_path, :if => Proc.new { User.current.logged? }
end

Redmine::MenuManager.map :application_menu do |menu|
  # Empty
end

Redmine::MenuManager.map :admin_menu do |menu|
  include TemplatesHelper
  menu.push :projects, {:controller => 'admin', :action => 'projects'}, :caption => :label_project_plural
  menu.push :users, {:controller => 'users'}, :caption => :label_user_plural
  menu.push(:templates, { :controller => 'templates', :action => 'index' }, {
            :last => true,
            :children => Proc.new { |p|
              #@project = p # @project used in the helper
              template_settings_tabs.collect do |tab|
                Redmine::MenuManager::MenuItem.new("settings-#{tab[:name]}".to_sym,
                           { :controller => 'templates', :action => tab[:action], :id => p, :tab => tab[:name] },
                           {
                             :caption => tab[:label],
                             :parent => :templates
                           })
              end
            },
            :caption => :label_template_plural
          })

end

Redmine::MenuManager.map :pjconfig_menu do |menu|
  include TemplatesHelper
  menu.push :projects, {:controller => 'pjconfig', :action => 'projects'}, :caption => :label_project_plural

end

Redmine::MenuManager.map :content_menu do |menu|
    include ContentsHelper
    menu.push(:project_content, { :controller => 'contents', :action => 'project_content' }, {
              :last => true,
              :children => Proc.new { |p|
                #@project = p # @project used in the helper
                project_content_tabs.collect do |tab|
                  Redmine::MenuManager::MenuItem.new("project_content-#{tab[:name]}",
                           { :controller => tab[:controller], :action => tab[:action], :id => p, :tab => tab[:name] },
                           {
                             :caption => tab[:label],
                             :parent => :project_content
                           })
                end
              },
              :caption => Proc.new { |p| p.name }
            })
end

Redmine::MenuManager.map :report_menu do |menu|
  menu.push( :report, {:controller => 'report_task', :action => 'tasks'},{
              :last => true,
              :caption => Proc.new { |p| p.name }
            })
end

Redmine::MenuManager.map :project_menu do |menu|
  include ProjectsHelper

  # TODO: refactor to a helper that is available before app/helpers along with the other procs.
  issue_query_proc = Proc.new { |p|
    ##### Taken from IssuesHelper
    # User can see public queries and his own queries
    visible = ARCondition.new(["is_public = ? OR user_id = ?", true, (User.current.logged? ? User.current.id : 0)])
    # Project specific queries and global queries
    visible << (p.nil? ? ["project_id IS NULL"] : ["project_id IS NULL OR project_id = ?", p.id])
    sidebar_queries = Query.find(:all,
                                 :select => 'id, name',
                                 :order => "name ASC",
                                 :conditions => visible.conditions)

    sidebar_queries.collect do |query|
      Redmine::MenuManager::MenuItem.new("query-#{query.id}".to_sym, { :controller => 'issues', :action => 'index', :project_id => p, :query_id => query }, {
                                           :caption => query.name,
                                           :param => :project_id,
                                           :parent => :issues
                                         })
    end
  }

  menu.push(:overview, { :controller => 'projects', :action => 'show' })
 # menu.push(:activity, { :controller => 'activities', :action => 'index' })
 
  menu.push(:settings, { :controller => 'projects', :action => 'settings' }, {
              :last => true,
              :children => Proc.new { |p|
                @project = p # @project used in the helper
                project_settings_tabs.collect do |tab|
                  Redmine::MenuManager::MenuItem.new("settings-#{tab[:name]}".to_sym,
                                                     { :controller => tab[:controller], :action => tab[:action], :id => p, :tab => tab[:name] },
                                                     {
                                                       :caption => tab[:label]
                                                     })
                end
              }
            })
end

Redmine::Activity.map do |activity|
  # activity.register :issues, :class_name => 'Issue'
  # activity.register :changesets
  # activity.register :news
  # activity.register :documents, :class_name => %w(Document Attachment)
  # activity.register :files, :class_name => 'Attachment'
  # activity.register :wiki_edits, :class_name => 'WikiContent', :default => false
  # activity.register :messages, :default => false
  # activity.register :time_entries, :default => false
  #activity.register :news
  #activity.register :weibo
end

Redmine::Search.map do |search|
  search.register :issues
  search.register :news
  search.register :documents
  search.register :changesets
  search.register :wiki_pages
  search.register :messages
  search.register :projects
end

Redmine::WikiFormatting.map do |format|
  format.register :textile, Redmine::WikiFormatting::Textile::Formatter, Redmine::WikiFormatting::Textile::Helper
end

ActionView::Template.register_template_handler :rsb, Redmine::Views::ApiTemplateHandler
