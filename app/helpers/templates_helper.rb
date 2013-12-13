module TemplatesHelper

	def template_settings_tabs
    tabs = [
            {:name => 'news', :action => :view_template, :partial => 'templates/news', :label => :label_news_template},
           	{:name => 'weibo', :action => :view_template, :partial => 'templates/weibo', :label => :label_weibo_template},
           	{:name => 'forum', :action => :view_template, :partial => 'templates/forum', :label => :label_forum_template},
           	{:name => 'blog', :action => :view_template, :partial => 'templates/blog', :label => :label_blog_template}
           #{:name => 'members', :action => :manage_members, :partial => 'projects/settings/members', :label => :label_member_plural},
            ]
    
  end
end
