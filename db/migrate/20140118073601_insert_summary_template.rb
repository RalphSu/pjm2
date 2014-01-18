#encoding: utf-8

class InsertSummaryTemplate < ActiveRecord::Migration
  def self.up
  	summary_platform = Template.create! :template_type => "汇总数据类模板",
  		:column_name => "平台"
        summary_platform.save!

  	summary_rank = Template.create! :template_type => "汇总数据类模板",
  		:column_name => "排名"
        summary_rank.save!

        summary_number = Template.create! :template_type => "汇总数据类模板",
  		:column_name => "数字"
        summary_number.save!

        summary_date = Template.create! :template_type => "汇总数据类模板",
  		:column_name => "日期"
        summary_date.save!

        summary_screenshot = Template.create! :template_type => "汇总数据类模板",
  		:column_name => "截图"
        summary_screenshot.save!

  end

  def self.down
  end
end
