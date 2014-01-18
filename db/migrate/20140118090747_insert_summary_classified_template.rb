#encoding: utf-8

class InsertSummaryClassifiedTemplate < ActiveRecord::Migration
  def self.up

  	summary_platform= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "汇总数据模板","平台"])

  	summary_rank= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "汇总数据模板","排名"])

  	summary_number= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "汇总数据模板","数字"])

  	summary_date= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "汇总数据模板","日期"])

  	summary_screenshot= Template.find(:first,
        	:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "汇总数据模板","截图"])


	summary_pc_1 = SummaryClassified.create! :classified => "PC趋势",
		:template => summary_platform
	summary_pc_1.save!

	summary_pc_2 = SummaryClassified.create! :classified => "PC趋势",
		:template => summary_number
	summary_pc_2.save!

	summary_pc_3 = SummaryClassified.create! :classified => "PC趋势",
		:template => summary_date
	summary_pc_3.save!

	summary_pc_4 = SummaryClassified.create! :classified => "PC趋势",
		:template => summary_screenshot
	summary_pc_4.save!


	summary_mobile_1 = SummaryClassified.create! :classified => "移动趋势",
		:template => summary_platform
	summary_mobile_1.save!

	summary_mobile_2 = SummaryClassified.create! :classified => "移动趋势",
		:template => summary_number
	summary_mobile_2.save!

	summary_mobile_3 = SummaryClassified.create! :classified => "移动趋势",
		:template => summary_date
	summary_mobile_3.save!

	summary_mobile_4 = SummaryClassified.create! :classified => "移动趋势",
		:template => summary_screenshot
	summary_mobile_4.save!


	summary_total_1 = SummaryClassified.create! :classified => "整体趋势",
		:template => summary_platform
	summary_total_1.save!

	summary_total_2 = SummaryClassified.create! :classified => "整体趋势",
		:template => summary_number
	summary_total_2.save!

	summary_total_3 = SummaryClassified.create! :classified => "整体趋势",
		:template => summary_date
	summary_total_3.save!

	summary_total_4 = SummaryClassified.create! :classified => "整体趋势",
		:template => summary_screenshot
	summary_total_4.save!


	summary_billboard_1 = SummaryClassified.create! :classified => "百度风云榜",
		:template => summary_platform
	summary_billboard_1.save!

	summary_billboard_2 = SummaryClassified.create! :classified => "百度风云榜",
		:template => summary_rank
	summary_billboard_2.save!

	summary_billboard_3 = SummaryClassified.create! :classified => "百度风云榜",
		:template => summary_date
	summary_billboard_3.save!

	summary_billboard_4 = SummaryClassified.create! :classified => "百度风云榜",
		:template => summary_screenshot
	summary_billboard_4.save!


	summary_zhidao_1 = SummaryClassified.create! :classified => "百度知道",
		:template => summary_platform
	summary_zhidao_1.save!

	summary_zhidao_2 = SummaryClassified.create! :classified => "百度知道",
		:template => summary_number
	summary_zhidao_2.save!

	summary_zhidao_3 = SummaryClassified.create! :classified => "百度知道",
		:template => summary_date
	summary_zhidao_3.save!

	summary_zhidao_4 = SummaryClassified.create! :classified => "百度知道",
		:template => summary_screenshot
	summary_zhidao_4.save!


	summary_baidu_1 = SummaryClassified.create! :classified => "百度搜索",
		:template => summary_platform
	summary_baidu_1.save!

	summary_baidu_2 = SummaryClassified.create! :classified => "百度搜索",
		:template => summary_number
	summary_baidu_2.save!

	summary_baidu_3 = SummaryClassified.create! :classified => "百度搜索",
		:template => summary_date
	summary_baidu_3.save!

	summary_baidu_4 = SummaryClassified.create! :classified => "百度搜索",
		:template => summary_screenshot
	summary_baidu_4.save!


	summary_news_1 = SummaryClassified.create! :classified => "百度新闻",
		:template => summary_platform
	summary_baidu_1.save!

	summary_news_2 = SummaryClassified.create! :classified => "百度新闻",
		:template => summary_number
	summary_news_2.save!

	summary_news_3 = SummaryClassified.create! :classified => "百度新闻",
		:template => summary_date
	summary_news_3.save!

	summary_news_4 = SummaryClassified.create! :classified => "百度新闻",
		:template => summary_screenshot
	summary_news_4.save!



	summary_index_1 = SummaryClassified.create! :classified => "微指数",
		:template => summary_platform
	summary_index_1.save!

	summary_index_2 = SummaryClassified.create! :classified => "微指数",
		:template => summary_number
	summary_index_2.save!

	summary_index_3 = SummaryClassified.create! :classified => "微指数",
		:template => summary_date
	summary_index_3.save!

	summary_index_4 = SummaryClassified.create! :classified => "微指数",
		:template => summary_screenshot
	summary_index_4.save!


	summary_weibo_search_1 = SummaryClassified.create! :classified => "微博搜索",
		:template => summary_platform
	summary_weibo_search_1.save!

	summary_weibo_search_2 = SummaryClassified.create! :classified => "微博搜索",
		:template => summary_number
	summary_weibo_search_2.save!

	summary_weibo_search_3 = SummaryClassified.create! :classified => "微博搜索",
		:template => summary_date
	summary_weibo_search_3.save!

	summary_weibo_search_4 = SummaryClassified.create! :classified => "微博搜索",
		:template => summary_screenshot
	summary_weibo_search_4.save!

  end

  def self.down
  end
end
