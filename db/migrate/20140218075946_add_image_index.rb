class AddImageIndex < ActiveRecord::Migration
  def self.up
  	add_index :images, [:url, :image_date]
  end

  def self.down
  	remove_index :image, [:url, :image_date]
  end
end
