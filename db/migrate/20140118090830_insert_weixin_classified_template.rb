#encoding: utf-8

class InsertWeixinClassifiedTemplate < ActiveRecord::Migration
  def self.up

  	weixin_platform= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","平台"])

  	weixin_content= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","内容"])

  	weixin_link= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","链接"])

  	weixin_tweets= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","转发数"])

  	weixin_comments= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","评论数"])

  	weixin_fans= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","粉丝数"])

  	weixin_nice= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","点赞"])

  	weixin_hot= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","热门微视"])

  	weixin_tag= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","热门标签"])

  	weixin_date= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","日期"])

  	weixin_screenshot= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","截图"])


	weixin_view_1 = WeixinClassified.create! :classified => "微视",
		:template => weixin_platform
	weixin_view_1.save!

    weixin_view_2 = WeixinClassified.create! :classified => "微视",
      :template => weixin_content
    weixin_view_2.save!

    weixin_view_3 = WeixinClassified.create! :classified => "微视",
      :template => weixin_link
    weixin_view_3.save!

    weixin_view_4 = WeixinClassified.create! :classified => "微视",
      :template => weixin_tweets
    weixin_view_4.save!

    weixin_view_5 = WeixinClassified.create! :classified => "微视",
      :template => weixin_comments
    weixin_view_5.save!

    weixin_view_6 = WeixinClassified.create! :classified => "微视",
      :template => weixin_fans
    weixin_view_6.save!

    weixin_view_7 = WeixinClassified.create! :classified => "微视",
      :template => weixin_nice
    weixin_view_7.save!

    weixin_view_8 = WeixinClassified.create! :classified => "微视",
      :template => weixin_hot
    weixin_view_8.save!

    weixin_view_9 = WeixinClassified.create! :classified => "微视",
      :template => weixin_tag
    weixin_view_9.save!

    weixin_view_10 = WeixinClassified.create! :classified => "微视",
      :template => weixin_date
    weixin_view_10.save!

    weixin_view_11 = WeixinClassified.create! :classified => "微视",
      :template => weixin_screenshot
    weixin_view_11.save!


    weixin_official_1 = WeixinClassified.create! :classified => "官方微信",
      :template => weixin_platform
    weixin_official_1.save!

    weixin_official_2 = WeixinClassified.create! :classified => "官方微信",
      :template => weixin_content
    weixin_official_2.save!

    weixin_official_3 = WeixinClassified.create! :classified => "官方微信",
      :template => weixin_nice
    weixin_official_3.save!

    weixin_official_4 = WeixinClassified.create! :classified => "官方微信",
      :template => weixin_date
    weixin_official_4.save!

    weixin_official_5 = WeixinClassified.create! :classified => "官方微信",
      :template => weixin_screenshot
    weixin_official_5.save!


    weixin_commentator_1 = WeixinClassified.create! :classified => "娱评人微信",
      :template => weixin_platform
    weixin_commentator_1.save!

    weixin_commentator_2 = WeixinClassified.create! :classified => "娱评人微信",
      :template => weixin_content
    weixin_commentator_2.save!

    weixin_commentator_3 = WeixinClassified.create! :classified => "娱评人微信",
      :template => weixin_nice
    weixin_commentator_3.save!

    weixin_commentator_4 = WeixinClassified.create! :classified => "娱评人微信",
      :template => weixin_date
    weixin_commentator_4.save!

    weixin_commentator_5 = WeixinClassified.create! :classified => "娱评人微信",
      :template => weixin_screenshot
    weixin_commentator_5.save!



    weixin_media_1 = WeixinClassified.create! :classified => "媒体人微信",
      :template => weixin_platform
    weixin_media_1.save!

    weixin_media_2 = WeixinClassified.create! :classified => "媒体人微信",
      :template => weixin_content
    weixin_media_2.save!

    weixin_media_3 = WeixinClassified.create! :classified => "媒体人微信",
      :template => weixin_nice
    weixin_media_3.save!

    weixin_media_4 = WeixinClassified.create! :classified => "媒体人微信",
      :template => weixin_date
    weixin_media_4.save!

    weixin_media_5 = WeixinClassified.create! :classified => "媒体人微信",
      :template => weixin_screenshot
    weixin_media_5.save!

  end

  def self.down
  end
end
