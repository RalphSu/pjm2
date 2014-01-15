#encoding: utf-8
class AddWeiboTemplateColumns < ActiveRecord::Migration
  def self.up
        weibo_subject= Template.create! :template_type => "微博类模板",
                                 :column_name => "主题"
        weibo_subject.save!
      
        weibo_discussion= Template.create! :template_type => "微博类模板",
                                 :column_name => "讨论数"
        weibo_discussion.save!

   	   weibo_order= Template.create! :template_type => "微博类模板",
                                 :column_name => "排名"
        weibo_order.save!

        weibo_place= Template.create! :template_type => "微博类模板",
                                 :column_name => "位置"
        weibo_place.save!

        weibo_hottopic= Template.create! :template_type => "微博类模板",
                                 :column_name => "热门话题榜"
        weibo_hottopic.save!

        weibo_lastday= Template.create! :template_type => "微博类模板",
                                 :column_name => "持续天数"
        weibo_lastday.save!

        weibo_activityname= Template.create! :template_type => "微博类模板",
                                 :column_name => "活动名称"
        weibo_activityname.save!

        weibo_attendees= Template.create! :template_type => "微博类模板",
                                 :column_name => "参加人数"
        weibo_attendees.save!

       
        

  end

  def self.down
  end


end
