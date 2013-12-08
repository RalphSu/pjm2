module ContentsHelper

  def project_content_tabs
    tabs = [
            {:name => 'news', :action => :news, :partial => 'contents/news', :label => :label_news},    
            {:name => 'weibo', :action => :weibo, :partial => 'contents/weibo', :label => :label_weibo},
            ]
    tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
  end

  def get_project_name(id)
  	return id
  end 
end
