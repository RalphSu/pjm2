#encoding: utf-8
class RemoveBinduvideoBlog < ActiveRecord::Migration
  def self.up
  	ff=BlogClassified.find(:all, :conditions => {:classified =>"病毒视频" })
  	ff.each do |f|
  		BlogClassified.destroy(f)
  	end
  end

  def self.down
  end
end
