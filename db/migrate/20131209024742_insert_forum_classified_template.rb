#encoding: utf-8
class InsertForumClassifiedTemplate < ActiveRecord::Migration
  def self.up
  	 forum_platform= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","论坛"])

     forum_area= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","板块"])

     forum_if_recommend= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","是否推荐"])

     forum_title= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","标题"])


     forum_hyperlink= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","链接"])

     forum_click_num= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","点击数"])

 	 forum_reply_num= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","回复数"])

  	 forum_date= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","日期"])
	  
  	 forum_if_awesome= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","是否加精"])
	 
  	 forum_if_top= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","是否置顶"])


  	 forum_forum_1 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_platform
     forum_forum_1.save!

     forum_forum_2 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_area
     forum_forum_2.save!

     forum_forum_3 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_if_recommend
     forum_forum_3.save!

     forum_forum_4 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_title
     forum_forum_4.save!

     forum_forum_5 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_hyperlink
     forum_forum_5.save!

     forum_forum_6 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_click_num
     forum_forum_6.save!

     forum_forum_7 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_reply_num
     forum_forum_7.save!

     forum_forum_7 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_date
     forum_forum_7.save!



 	 forum_baidu_1 = ForumClassified.create! :classified => "百度贴吧",
                                 :template => forum_platform
     forum_baidu_1.save!


     forum_baidu_4 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_title
     forum_baidu_4.save!

     forum_baidu_5 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_hyperlink
     forum_baidu_5.save!

     forum_baidu_6 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_click_num
     forum_baidu_6.save!

     forum_baidu_7 = ForumClassified.create! :classified => "论坛",
                                 :template => forum_reply_num
     forum_baidu_7.save!

 

  end

  def self.down
  end
end
