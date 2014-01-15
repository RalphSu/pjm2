#encoding: utf-8
class AddWeiboTemplatePicColumn < ActiveRecord::Migration
  def self.up
  	 weibo_pic= Template.create! :template_type => "微博类模板",
                                 :column_name => "图片"
        weibo_pic.save!
  end

  def self.down
  end
end
