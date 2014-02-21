#encoding: utf-8
class AddWeihuatiDateColumn < ActiveRecord::Migration
  def self.up

    weibo_date= Template.find(:first,
          :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微博类模板","日期"])

    weibo_weihuati_4 = WeiboClassified.create! :classified => "微话题",
                                 :template => weibo_date
    weibo_weihuati_4.save!
  end

  def self.down
  end
end




