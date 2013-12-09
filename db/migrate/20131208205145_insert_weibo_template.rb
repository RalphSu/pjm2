#encoding: utf-8
class InsertWeiboTemplate < ActiveRecord::Migration
  def self.up
        weibo_platform = Template.create! :template_type => "微薄类模板",
                                 :column_name => "平台"
        weibo_platform.save!
      
        weibo_content= Template.create! :template_type => "微薄类模板",
                                 :column_name => "微薄内容"
        weibo_content.save!

   		weibo_hyperlink= Template.create! :template_type => "微薄类模板",
                                 :column_name => "链接"
        weibo_hyperlink.save!

        weibo_tweets= Template.create! :template_type => "微薄类模板",
                                 :column_name => "转发数"
        weibo_tweets.save!

        weibo_comments= Template.create! :template_type => "微薄类模板",
                                 :column_name => "评论数"
        weibo_comments.save!

        weibo_fans= Template.create! :template_type => "微薄类模板",
                                 :column_name => "粉丝数"
        weibo_fans.save!

        weibo_top= Template.create! :template_type => "微薄类模板",
                                 :column_name => "热门微薄排名"
        weibo_top.save!

        weibo_topic= Template.create! :template_type => "微薄类模板",
                                 :column_name => "所属话题"
        weibo_topic.save!

        weibo_sharecontent= Template.create! :template_type => "微薄类模板",
                                 :column_name => "分享链接内容"
        weibo_sharecontent.save!


        weibo_activity= Template.create! :template_type => "微薄类模板",
                                 :column_name => "所属活动"
        weibo_activity.save!
        

        weibo_date= Template.create! :template_type => "微薄类模板",
                                 :column_name => "日期"
        weibo_date.save!
        

  end

  def self.down
  end
end
