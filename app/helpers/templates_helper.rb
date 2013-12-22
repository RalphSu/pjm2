module TemplatesHelper

	def template_settings_tabs
    tabs = [
            {:name => 'news', :action => :index, :partial => 'templates/news', :label => :label_news_template},
           	{:name => 'weibo', :action => :index, :partial => 'templates/weibo', :label => :label_weibo_template},
           	{:name => 'forum', :action => :index, :partial => 'templates/forum', :label => :label_forum_template},
           	{:name => 'blog', :action => :index, :partial => 'templates/blog', :label => :label_blog_template}
            ]
    
  end
end
