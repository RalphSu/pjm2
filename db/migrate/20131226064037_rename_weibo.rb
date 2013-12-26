#encoding: utf-8
class RenameWeibo < ActiveRecord::Migration
  def self.up

  	 manaRole= WeiboClassified.find(:all,
                            :conditions => ["#{WeiboClassified.table_name}.classified = ? ", "微薄推广"])
      manaRole.each do |item|
		item.classified="微博推广"
		item.save
	end
  end

  def self.down
  end
end
