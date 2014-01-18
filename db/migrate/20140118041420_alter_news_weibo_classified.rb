#encoding: utf-8
class AlterNewsWeiboClassified < ActiveRecord::Migration
  def self.up
  	# 1.  add mobile news
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

	 news_rank= Template.find(:first,
			:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "新闻类模板","排名"])

	 news_mobile_1 = NewsClassified.create! :classified => "手机新闻客户端",
								 :template => news_publish_platform
	 news_mobile_1.save!

	 news_mobile_2 = NewsClassified.create! :classified => "手机新闻客户端",
								 :template => news_location
	 news_mobile_2.save!

	 news_mobile_3 = NewsClassified.create! :classified => "手机新闻客户端",
								 :template => news_title
	 news_mobile_3.save!

	 news_mobile_4 = NewsClassified.create! :classified => "手机新闻客户端",
								 :template => news_hyperlink
	 news_mobile_4.save!

	 news_mobile_5 = NewsClassified.create! :classified => "手机新闻客户端",
								 :template => news_date
	 news_mobile_5.save!

	 news_mobile_6 = NewsClassified.create! :classified => "手机新闻客户端",
								 :template => news_rank
	 news_mobile_6.save!

	 # 2. add "Zan" to all weibo claissifieds..
	 template_zan = Template.find(:first,
			:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","点赞"])
	 classifieds = WeiboClassified.all(:select => "DISTINCT(classified)")
	 classifieds.each do |c|
	 	weibo_zan_classified = WeiboClassified.create! :classified => c.classified, :template => template_zan
	 	weibo_zan_classified.save!
	 end

  end

  def self.down
  end
end
