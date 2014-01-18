#encoding: utf-8
class DropScreenshotWeixin < ActiveRecord::Migration
  def self.up

 	weixin_screenshot= Template.find(:first,
        		:conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "微信类模板","截图"])

 	weixin_screenshot_classifieds = WeixinClassified.find(:all, :conditions=> {:template_id => weixin_screenshot.id})
 	weixin_screenshot_classifieds.each do |e|
 		e.destroy
 	end

 	weixin_screenshot.destroy

  end

  def self.down
  end
end
