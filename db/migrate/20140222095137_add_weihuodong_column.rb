#encoding: utf-8
class AddWeihuodongColumn < ActiveRecord::Migration
  def self.up

   
   weibo_tweets= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","转发数"])

	   weibo_comments= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","评论数"])


    weibo_weihuati_4 = WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_tweets
    weibo_weihuati_4.save!


        weibo_weihuati_5 = WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_comments
    weibo_weihuati_5.save!
  end

  def self.down
  end
end
