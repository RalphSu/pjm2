class AlterImageFilepath < ActiveRecord::Migration
  def self.up
  	  change_column  :images, :file_path, :string, :limit => 1000
  	
  end

  def self.down
  end
end
