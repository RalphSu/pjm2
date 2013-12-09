module ContentsHelper

  def project_content_tabs
    tabs = [
            {:name => 'news', :controller=> 'news_release', :action => 'index', :partial => 'contents/news', :label => :label_news},    
            {:name => 'weibo',  :controller=> 'weibo', :action => 'index', :partial => 'contents/weibo', :label => :label_weibo},
            #{:name => 'press', :action => press, :partial => 'contents/press', :label => :label_press},
            #{:name => 'blog', :action => :blog, :partial => 'contents/blog', :label => :label_blog},
            #{:name => 'micro_talk', :action => :micro_talk, :partial => 'contents/micro_talk', :label => :label_micro_talk},
            #{:name => 'micro_topic', :action => :micro_topic, :partial => 'contents/micro_topic', :label => :label_micro_topic},
            #{:name => 'forum', :action => :forum, :partial => 'contents/forum', :label => :label_forum},
            ]
    tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
    tabs
  end

  def get_project_name(id)
  	return id
  end 
end
