#encoding: utf-8
class RenameAdminUser < ActiveRecord::Migration
  def self.up
  	admin = User.find(:first, :conditions=>{:admin=>1}, :order=>"id")
  	unless admin.nil?
	  	if admin.language == 'en'
	  		admin.language = "zh"
	  	end
	  	if admin.login == "admin"
	  		admin.firstname='科翼管理员'
	  	end
	  	admin.save!
	  end
  end

  def self.down
  end
end
