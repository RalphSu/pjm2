#encoding: utf-8
class RenameWeibo2 < ActiveRecord::Migration
  def self.up
  	 manaRole= WeiboClassified.find(:all,
                            :conditions => ["#{WeiboClassified.table_name}.classified = ? ", "微薄直发"])
      manaRole.each do |item|
		item.classified="微博直发"
		item.save
	end

	manaRole= WeiboClassified.find(:all,
                            :conditions => ["#{WeiboClassified.table_name}.classified = ? ", "微薄特殊发布"])
      manaRole.each do |item|
		item.classified="微博特殊发布"
		item.save
	end

	manaRole= WeiboClassified.find(:all,
                            :conditions => ["#{WeiboClassified.table_name}.classified = ? ", "官微及艺人微薄发布"])
      manaRole.each do |item|
		item.classified="官微及艺人微博发布"
		item.save
	end

	manaRole= WeiboClassified.find(:all,
                            :conditions => ["#{WeiboClassified.table_name}.classified = ? ", "大号转发微薄"])
      manaRole.each do |item|
		item.classified="大号转发微博"
		item.save
	end
  end

  def self.down
  end
end
