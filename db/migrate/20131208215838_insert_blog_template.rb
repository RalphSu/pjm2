#encoding: utf-8
class InsertBlogTemplate < ActiveRecord::Migration
  def self.up
  	    blog_host = Template.create! :template_type => "博客类模板",
                                 :column_name => "博主"
        blog_host.save!
      
        blog_platform= Template.create! :template_type => "博客类模板",
                                 :column_name => "平台"
        blog_platform.save!

        blog_if_recommend= Template.create! :template_type => "博客类模板",
                                 :column_name => "是否推荐"
        blog_if_recommend.save!

        blog_subject= Template.create! :template_type => "博客类模板",
                                 :column_name => "主题"
        blog_subject.save!

        blog_hyperlink= Template.create! :template_type => "博客类模板",
                                 :column_name => "链接"
        blog_hyperlink.save!       

        blog_click_num= Template.create! :template_type => "博客类模板",
                                 :column_name => "点击数"
        blog_click_num.save!   

   		blog_reply_num= Template.create! :template_type => "博客类模板",
                                 :column_name => "回复数"
        blog_reply_num.save! 

        blog_date= Template.create! :template_type => "博客类模板",
                                 :column_name => "日期"
        blog_date.save!

  end

  def self.down
  end
end
