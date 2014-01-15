#encoding: utf-8
class InsertWeiboNewclassifieds < ActiveRecord::Migration
 def self.up
  	 weibo_subject= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","主题"])

     weibo_discussion= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","讨论数"])

     weibo_order= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","排名"])

	   weibo_place= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","位置"])

	   weibo_hottopic= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","热门话题榜"])

	   weibo_lastday= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","持续天数"])

	   weibo_activityname= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","活动名称"])

	   weibo_attendees= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","参加人数"])

	  weibo_date= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","日期"])

	    weibo_hyperlink= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","链接"])



     weibo_weifangtan_1= WeiboClassified.create! :classified => "微访谈",
                                 :template => weibo_subject
     weibo_weifangtan_1.save!

     weibo_weifangtan_2 = WeiboClassified.create! :classified => "微访谈",
                                 :template => weibo_hyperlink
     weibo_weifangtan_2.save!

     weibo_weifangtan_3 = WeiboClassified.create! :classified => "微访谈",
                                 :template => weibo_discussion
     weibo_weifangtan_3.save!

     weibo_weifangtan_4 = WeiboClassified.create! :classified => "微访谈",
                                 :template => weibo_date
     weibo_weifangtan_4.save!

     weibo_weihuati_1 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_subject
     weibo_weihuati_1.save!

     weibo_weihuati_2 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_hyperlink
     weibo_weihuati_2.save!

     weibo_weihuati_3 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_order
     weibo_weihuati_3.save!
   
     weibo_weihuati_4 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_place
     weibo_weihuati_4.save!

         weibo_weihuati_5 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_hottopic
     weibo_weihuati_5.save!

      weibo_weihuati_6 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_discussion
     weibo_weihuati_6.save!

      weibo_weihuati_7 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_lastday
     weibo_weihuati_7.save!



     weibo_weihuodong_1 = WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_activityname
     weibo_weihuodong_1.save!

     weibo_weihuodong_2 = WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_hyperlink
     weibo_weihuodong_2.save!

     weibo_weihuodong_3 = WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_attendees
     weibo_weihuodong_3.save!

     weibo_weihuodong_4 = WeiboClassified.create! :classified => "微活动",
                                 :template => weibo_date
     weibo_weihuodong_4.save!



    
  

  end

  def self.down
  end
end
