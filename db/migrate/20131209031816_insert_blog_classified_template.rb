#encoding: utf-8
class InsertBlogClassifiedTemplate < ActiveRecord::Migration
  def self.up


        blog_host= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","博主"])

        blog_platform= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","平台"])

        blog_if_recommend= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","是否推荐"])

        blog_subject= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","主题"])

        blog_hyperlink= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","链接"])

        blog_click_num= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","点击数"])

        blog_reply_num= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","回复数"])

        blog_date= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "博客类模板","日期"])


       blog_sina_1 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_host
       blog_sina_1.save!

       blog_sina_2 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_platform
       blog_sina_2.save!

       blog_sina_3 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_if_recommend
       blog_sina_3.save!


       blog_sina_4 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_subject
       blog_sina_4.save!


       blog_sina_5 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_hyperlink
       blog_sina_5.save!


       blog_sina_6 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_click_num
       blog_sina_6.save!


       blog_sina_7 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_reply_num
       blog_sina_7.save!

       blog_sina_8 = BlogClassified.create! :classified => "新浪博客",
                                 :template => blog_date
       blog_sina_8.save!



       	blog_tencent_1 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_host
       blog_tencent_1.save!

       blog_tencent_2 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_platform
       blog_tencent_2.save!

       blog_tencent_3 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_if_recommend
       blog_tencent_3.save!


       blog_tencent_4 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_subject
       blog_tencent_4.save!


       blog_tencent_5 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_hyperlink
       blog_tencent_5.save!


       blog_tencent_6 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_click_num
       blog_tencent_6.save!


       blog_tencent_7 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_reply_num
       blog_tencent_7.save!

       blog_tencent_8 = BlogClassified.create! :classified => "腾讯博客",
                                 :template => blog_date
       blog_tencent_8.save!



       	blog_sohu_1 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_host
       blog_sohu_1.save!

       blog_sohu_2 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_platform
       blog_sohu_2.save!

       blog_sohu_3 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_if_recommend
       blog_sohu_3.save!


       blog_sohu_4 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_subject
       blog_sohu_4.save!


       blog_sohu_5 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_hyperlink
       blog_sohu_5.save!


       blog_sohu_6 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_click_num
       blog_sohu_6.save!


       blog_sohu_7 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_reply_num
       blog_sohu_7.save!

       blog_sohu_8 = BlogClassified.create! :classified => "搜狐博客",
                                 :template => blog_date
       blog_sohu_8.save!


       	blog_163_1 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_host
       blog_163_1.save!

       blog_163_2 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_platform
       blog_163_2.save!

       blog_163_3 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_if_recommend
       blog_163_3.save!


       blog_163_4 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_subject
       blog_163_4.save!


       blog_163_5 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_hyperlink
       blog_163_5.save!


       blog_163_6 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_click_num
       blog_163_6.save!


       blog_163_7 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_reply_num
       blog_163_7.save!

       blog_163_8 = BlogClassified.create! :classified => "网易博客",
                                 :template => blog_date
       blog_163_8.save!

       	blog_tianya_1 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_host
       blog_tianya_1.save!

       blog_tianya_2 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_platform
       blog_tianya_2.save!

       blog_tianya_3 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_if_recommend
       blog_tianya_3.save!


       blog_tianya_4 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_subject
       blog_tianya_4.save!


       blog_tianya_5 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_hyperlink
       blog_tianya_5.save!


       blog_tianya_6 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_click_num
       blog_tianya_6.save!


       blog_tianya_7 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_reply_num
       blog_tianya_7.save!

       blog_tianya_8 = BlogClassified.create! :classified => "天涯博客",
                                 :template => blog_date
       blog_tianya_8.save!



       	blog_baoliao_1 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_host
       blog_baoliao_1.save!

       blog_baoliao_2 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_platform
       blog_baoliao_2.save!

       blog_baoliao_3 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_if_recommend
       blog_baoliao_3.save!


       blog_baoliao_4 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_subject
       blog_baoliao_4.save!


       blog_baoliao_5 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_hyperlink
       blog_baoliao_5.save!


       blog_baoliao_6 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_click_num
       blog_baoliao_6.save!


       blog_baoliao_7 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_reply_num
       blog_baoliao_7.save!

       blog_baoliao_8 = BlogClassified.create! :classified => "爆料",
                                 :template => blog_date
       blog_baoliao_8.save!


       blog_sns_2 = BlogClassified.create! :classified => "SNS推广",
                                 :template => blog_platform
       blog_sns_2.save!


       blog_sns_4 = BlogClassified.create! :classified => "SNS推广",
                                 :template => blog_subject
       blog_sns_4.save!


       blog_sns_5 = BlogClassified.create! :classified => "SNS推广",
                                 :template => blog_hyperlink
       blog_sns_5.save!


       blog_sns_6 = BlogClassified.create! :classified => "SNS推广",
                                 :template => blog_click_num
       blog_sns_6.save!


       blog_sns_7 = BlogClassified.create! :classified => "SNS推广",
                                 :template => blog_reply_num
       blog_sns_7.save!



       blog_video_2 = BlogClassified.create! :classified => "病毒视频",
                                 :template => blog_platform
      blog_video_2.save!


      blog_video_5 = BlogClassified.create! :classified => "病毒视频",
                                 :template => blog_hyperlink
      blog_video_5.save!


      blog_video_6 = BlogClassified.create! :classified => "病毒视频",
                                 :template => blog_click_num
      blog_video_6.save!

  end

  def self.down
  end

end
