require 'csv'

module ContentsHelper

  def project_content_tabs
    tabs = [
            {:name => 'news', :controller=> 'news_release', :action => 'index', :partial => 'contents/news', :label => :label_news},    
            #{:name => 'weibo',  :controller=> 'weibo', :action => 'index', :partial => 'contents/weibo', :label => :label_weibo},
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

  ## represents a activity like news adding
  class UploadLine
    attr_accessor :entity, :items

    @entity
    @items
  end

  def deserializeCSV(csvContent)
    header = []
    headLine = true
    activityItems=[]
    unless csvContent.blank?
      arr_of_arrs = CSV.parse(csvContent)
      
      arr_of_arrs.each do |row|
        if headLine
          headLine = false
          row.each do |h|
            ## TODO check header existence??
            header << h
          end
        else
          ai = UploadLine.new
          news = NewsRelease.new
          ai.entity = news
          ai.items = []
          for i in 0...header.length
            unless row[i].nil?
              f = NewsReleaseField.new
              f.column_name=header[i]
              f.body=row[i]
              ai.items<<f
            end
          end
          activityItems << ai
        end
      end
      activityItems
    end
  end

  def deserializeExcel(excelContent)
    ## TODO :: add support for excel
  end

end
