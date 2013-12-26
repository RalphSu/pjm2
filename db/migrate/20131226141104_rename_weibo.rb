#encoding: utf-8
class RenameWeibo < ActiveRecord::Migration
  def self.up
  	WeiboClassified.find(:all, :conditions=>{:classified => "微薄推广"}).each do |wc|
  		wc.classified = "微博推广"
  		wc.save
  	end

  	WeiboClassified.find(:all, :conditions=>{:classified => "微薄直发"}).each do |wc|
  		wc.classified = "微博直发"
  		wc.save
  	end

  	WeiboClassified.find(:all, :conditions=>{:classified => "微薄特殊发布"}).each do |wc|
  		wc.classified = "微博特殊发布"
  		wc.save
  	end

  	WeiboClassified.find(:all, :conditions=>{:classified => "官微及艺人微薄发布"}).each do |wc|
  		wc.classified = "官微及艺人微博发布"
  		wc.save
  	end

  	WeiboClassified.find(:all, :conditions=>{:classified => "大号转发微薄"}).each do |wc|
  		wc.classified = "大号转发微博"
  		wc.save
  	end

  	# rename the template_type and column name
  	Template.find(:all, :conditions=>{:template_type => "微薄类模板"}).each do |wc|
  		wc.template_type = "微博类模板" 
  		wc.save
  	end
  	# template column_name
  	 Template.find(:all, :conditions=>{:column_name => "微薄内容"}).each do |wc|
  		wc.column_name = "微博内容" 
  		wc.save
  	end
  	Template.find(:all, :conditions=>{:column_name => "热门微薄排名"}).each do |wc|
  		wc.column_name = "热门微博排名" 
  		wc.save
  	end

  end

  def self.down

  end
end
