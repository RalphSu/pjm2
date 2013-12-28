#encoding: utf-8
class RenameBlogForum < ActiveRecord::Migration
  def self.up

  	# rename the template column name
  	Template.find(:all, :conditions=>{:column_name => "板块"}).each do |wc|
  		wc.column_name = "版块" 
  		wc.save
  	end
  	Template.find(:all, :conditions=>{:column_name => "回复数"}).each do |wc|
  		wc.column_name = "评论数"
  		wc.save
  	end
  	# 
  	Template.find(:all, :conditions=>{:template_type => '论坛类模板', :column_name => "评论数"}).each do |wc|
  		wc.column_name = "回复数"
  		wc.save
  	end

  end

  def self.down
  end
end
