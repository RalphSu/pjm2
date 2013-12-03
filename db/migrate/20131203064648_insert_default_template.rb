#encoding: utf-8
class InsertDefaultTemplate < ActiveRecord::Migration
  def self.up
  	#default template 
        news_publish_platform = Template.create! :template_type => "新闻类模板",
                                 :column_name => "发布平台"
        news_publish_platform.save!
      
        news_location= Template.create! :template_type => "新闻类模板",
                                 :column_name => "推荐位置"
        news_location.save!
      
        news_title= Template.create! :template_type => "新闻类模板",
                                 :column_name => "标题"
        news_title.save!

        news_hyperlink= Template.create! :template_type => "新闻类模板",
                                 :column_name => "链接"
        news_hyperlink.save!

        news_date= Template.create! :template_type => "新闻类模板",
                                 :column_name => "日期"
        news_date.save!

        news_entry_point= Template.create! :template_type => "新闻类模板",
                                 :column_name => "入口链接"
        news_entry_point.save!

  end

  def self.down
  end
end
