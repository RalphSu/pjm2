#encoding: utf-8
class AddBofangshuNews < ActiveRecord::Migration
  def self.up
  	 news_bofangshu= Template.create! :template_type => "新闻类模板",
                                 :column_name => "播放数"
        news_bofangshu.save!
  end

  def self.down
  end
end
