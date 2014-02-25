#encoding: utf-8
class RenameWeiboClassified < ActiveRecord::Migration
  def self.up
  	newValue = '娱评人播后'
  	fields = WeiboClassified.find(:all, :conditions=>{:classified=>'娱评人后播'})
  	fields.each do |f|
  		f.classified = newValue
  		f.save!
  	end
  end

  def self.down
  end
end
