#encoding: utf-8
class InsertWeiboClassifiedTemplate < ActiveRecord::Migration
  def self.up
  	 weibo_platform= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","平台"])

     weibo_content= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","微薄内容"])

     weibo_hyperlink= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","链接"])

	   weibo_tweets= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","转发数"])

	   weibo_comments= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","评论数"])

	   weibo_fans= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","粉丝数"])

	   weibo_top= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","热门微薄排名"])

	   weibo_topic= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","所属话题"])

	   weibo_sharecontent= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","分享链接内容"])

	   weibo_activity= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","所属活动"])

	   weibo_date= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微薄类模板","日期"])

     weibo_popularize_1 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_platform
     weibo_popularize_1.save!

     weibo_popularize_2 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_content
     weibo_popularize_2.save!

     weibo_popularize_3 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_hyperlink
     weibo_popularize_3.save!

     weibo_popularize_4 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_tweets
     weibo_popularize_4.save!

     weibo_popularize_5 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_comments
     weibo_popularize_5.save!

     weibo_popularize_6 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_fans
     weibo_popularize_6.save!

     weibo_popularize_7 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_top
     weibo_popularize_7.save!
   
     weibo_popularize_8 = WeiboClassified.create! :classified => "微薄推广",
                                 :template => weibo_date
     weibo_popularize_8.save!



     weibo_directs_1 = WeiboClassified.create! :classified => "微薄直发",
                                 :template => weibo_platform
     weibo_directs_1.save!

     weibo_directs_3 = WeiboClassified.create! :classified => "微薄直发",
                                 :template => weibo_hyperlink
     weibo_directs_3.save!

     weibo_directs_8 = WeiboClassified.create! :classified => "微薄直发",
                                 :template => weibo_topic
     weibo_directs_8.save!

     weibo_directs_9 = WeiboClassified.create! :classified => "微薄直发",
                                 :template => weibo_date
     weibo_directs_9.save!



     weibo_precise_1 = WeiboClassified.create! :classified => "精准营销",
                                 :template => weibo_platform
     weibo_precise_1.save!

     weibo_precise_3 = WeiboClassified.create! :classified => "精准营销",
                                 :template => weibo_hyperlink
     weibo_precise_3.save!

     weibo_precise_8 = WeiboClassified.create! :classified => "精准营销",
                                 :template => weibo_topic
     weibo_precise_8.save!

     weibo_precise_9 = WeiboClassified.create! :classified => "精准营销",
                                 :template => weibo_date
     weibo_precise_9.save!


     weibo_commentator_guess_1 = WeiboClassified.create! :classified => "娱评人预告",
                                 :template => weibo_platform
     weibo_commentator_guess_1.save!

     weibo_commentator_guess_3 = WeiboClassified.create! :classified => "娱评人预告",
                                 :template => weibo_hyperlink
     weibo_commentator_guess_3.save!

     weibo_commentator_guess_4 = WeiboClassified.create! :classified => "娱评人预告",
                                 :template => weibo_fans
     weibo_commentator_guess_4.save!


     weibo_commentator_live_1 = WeiboClassified.create! :classified => "娱评人直播",
                                 :template => weibo_platform
     weibo_commentator_live_1.save!

     weibo_commentator_live_3 = WeiboClassified.create! :classified => "娱评人直播",
                                 :template => weibo_hyperlink
     weibo_commentator_live_3.save!

     weibo_commentator_live_4 = WeiboClassified.create! :classified => "娱评人直播",
                                 :template => weibo_fans
     weibo_commentator_live_4.save!


     weibo_commentator_after_1 = WeiboClassified.create! :classified => "娱评人后播",
                                 :template => weibo_platform
     weibo_commentator_after_1.save!

     weibo_commentator_after_3 = WeiboClassified.create! :classified => "娱评人后播",
                                 :template => weibo_hyperlink
     weibo_commentator_after_3.save!

     weibo_commentator_after_4 = WeiboClassified.create! :classified => "娱评人后播",
                                 :template => weibo_fans
     weibo_commentator_after_4.save!


     weibo_media_live_1 = WeiboClassified.create! :classified => "媒体记者直播",
                                 :template => weibo_platform
     weibo_media_live_1.save!

     weibo_media_live_3 = WeiboClassified.create! :classified => "媒体记者直播",
                                 :template => weibo_hyperlink
     weibo_media_live_3.save!

     weibo_media_live_4 = WeiboClassified.create! :classified => "媒体记者直播",
                                 :template => weibo_fans
     weibo_media_live_4.save!



     weibo_sina_1 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_platform
     weibo_sina_1.save!

     weibo_sina_2 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_content
     weibo_sina_2.save!

     weibo_sina_3 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_hyperlink
     weibo_sina_3.save!

     weibo_sina_4 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_tweets
     weibo_sina_4.save!

     weibo_sina_5 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_comments
     weibo_sina_5.save!

     weibo_sina_6 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_fans
     weibo_sina_6.save!

     weibo_sina_7 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_activity
     weibo_sina_7.save!
   
     weibo_sina_8 = WeiboClassified.create! :classified => "新浪官微发布",
                                 :template => weibo_date
     weibo_sina_8.save!


     weibo_tencent_1 = WeiboClassified.create! :classified => "腾讯官微发布",
                                 :template => weibo_platform
     weibo_tencent_1.save!

     weibo_tencent_2 = WeiboClassified.create! :classified => "腾讯官微发布",
                                 :template => weibo_content
     weibo_tencent_2.save!

     weibo_tencent_3 = WeiboClassified.create! :classified => "腾讯官微发布",
                                 :template => weibo_hyperlink
     weibo_tencent_3.save!

     weibo_tencent_4 = WeiboClassified.create! :classified => "腾讯官微发布",
                                 :template => weibo_tweets
     weibo_tencent_4.save!

     weibo_tencent_5 = WeiboClassified.create! :classified => "腾讯官微发布",
                                 :template => weibo_comments
     weibo_tencent_5.save!

     weibo_tencent_8 = WeiboClassified.create! :classified => "腾讯官微发布",
                                 :template => weibo_date
     weibo_tencent_8.save!


     weibo_special_1 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_platform
     weibo_special_1.save!

     weibo_special_2 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_content
     weibo_special_2.save!

     weibo_special_3 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_hyperlink
     weibo_special_3.save!

     weibo_special_4 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_tweets
     weibo_special_4.save!

     weibo_special_5 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_comments
     weibo_special_5.save!

     weibo_special_6 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_fans
     weibo_special_6.save!

     weibo_special_7 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_activity
     weibo_special_7.save!
   
     weibo_special_8 = WeiboClassified.create! :classified => "微薄特殊发布",
                                 :template => weibo_date
     weibo_special_8.save!


     weibo_star_1 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_platform
     weibo_star_1.save!

     weibo_star_2 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_content
     weibo_star_2.save!

     weibo_star_3 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_hyperlink
     weibo_star_3.save!

     weibo_star_4 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_tweets
     weibo_star_4.save!

     weibo_star_5 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_comments
     weibo_star_5.save!

     weibo_star_6 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_fans
     weibo_star_6.save!

     weibo_star_7 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_sharecontent
     weibo_star_7.save!
   
     weibo_star_8 = WeiboClassified.create! :classified => "官微及艺人微薄发布",
                                 :template => weibo_date
     weibo_star_8.save!


     weibo_vip_1 = WeiboClassified.create! :classified => "大号转发微薄",
                                 :template => weibo_platform
     weibo_vip_1.save!

   
     weibo_vip_3 = WeiboClassified.create! :classified => "大号转发微薄",
                                 :template => weibo_hyperlink
     weibo_vip_3.save!

     weibo_vip_4 = WeiboClassified.create! :classified => "大号转发微薄",
                                 :template => weibo_tweets
     weibo_vip_4.save!

     weibo_vip_5 = WeiboClassified.create! :classified => "大号转发微薄",
                                 :template => weibo_comments
     weibo_vip_5.save!

     weibo_vip_6 = WeiboClassified.create! :classified => "大号转发微薄",
                                 :template => weibo_fans
     weibo_vip_6.save!

     weibo_star_7 = WeiboClassified.create! :classified => "大号转发微薄",
                                 :template => weibo_activity
     weibo_star_7.save!
   
  

  end

  def self.down
  end
end
