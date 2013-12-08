#encoding: utf-8
class InsertNewsClassifiedTemplate < ActiveRecord::Migration
  def self.up
  	 news_publish_platform= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","发布平台"])

     news_location= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","推荐位置"])

     news_title= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","标题"])

	 news_hyperlink= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","链接"])

	 news_date= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","日期"])

	 news_entry_point= Template.find(:first,
            :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","入口链接"])


  	 news_popularize_1 = NewsClassified.create! :classified => "新闻稿推广",
                                 :template => news_publish_platform
     news_popularize_1.save!

     news_popularize_2 = NewsClassified.create! :classified => "新闻稿推广",
                                 :template => news_location
     news_popularize_2.save!

     news_popularize_3 = NewsClassified.create! :classified => "新闻稿推广",
                                 :template => news_title
     news_popularize_3.save!

     news_popularize_4 = NewsClassified.create! :classified => "新闻稿推广",
                                 :template => news_hyperlink
     news_popularize_4.save!

     news_popularize_5 = NewsClassified.create! :classified => "新闻稿推广",
                                 :template => news_date
     news_popularize_5.save!




  	 news_print_media_1 = NewsClassified.create! :classified => "平面媒体",
                                 :template => news_publish_platform
     news_print_media_1.save!


     news_print_media_3 = NewsClassified.create! :classified => "平面媒体",
                                 :template => news_title
     news_print_media_3.save!

     news_print_media_4 = NewsClassified.create! :classified => "平面媒体",
                                 :template => news_hyperlink
     news_print_media_4.save!



  	 news_video_popularize_1 = NewsClassified.create! :classified => "视频推广",
                                 :template => news_publish_platform
     news_video_popularize_1.save!

     news_video_popularize_2 = NewsClassified.create! :classified => "视频推广",
                                 :template => news_location
     news_video_popularize_2.save!

     news_video_popularize_4 = NewsClassified.create! :classified => "视频推广",
                                 :template => news_hyperlink
     news_video_popularize_4.save!

     news_video_popularize_5 = NewsClassified.create! :classified => "视频推广",
                                 :template => news_date
     news_video_popularize_5.save!


     news_video_1 = NewsClassified.create! :classified => "视频新闻",
                                 :template => news_publish_platform
     news_video_1.save!

     news_video_2 = NewsClassified.create! :classified => "视频新闻",
                                 :template => news_location
     news_video_2.save!

     news_video_3 = NewsClassified.create! :classified => "视频新闻",
                                 :template => news_title
     news_video_3.save!

     news_video_4 = NewsClassified.create! :classified => "视频新闻",
                                 :template => news_hyperlink
     news_video_4.save!

     news_video_5 = NewsClassified.create! :classified => "视频新闻",
                                 :template => news_date
     news_video_5.save!


     news_baidu_3 = NewsClassified.create! :classified => "百度知道",
                                 :template => news_title
     news_baidu_3.save!

     news_baidu_4 = NewsClassified.create! :classified => "百度知道",
                                 :template => news_hyperlink
     news_baidu_4.save!

  

  end

  def self.down
  end
end
