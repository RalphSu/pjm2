#encoding: utf-8
class InsertWeiboPicclassifieds < ActiveRecord::Migration
  def self.up
  		 weibo_pic= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","图片"])

     weibo_weifangtan_1= WeiboClassified.create! :classified => "微访谈",
                                 :template => weibo_pic
     weibo_weifangtan_1.save!

          weibo_weihuati_1= WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_pic
     weibo_weihuati_1.save!


          weibo_weihuodong_1= WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_pic
     weibo_weihuodong_1.save!
  end

  def self.down
  end
end
