class AlterTemplateColumns < ActiveRecord::Migration
  def self.up
  	change_column :images, :image_date, :date
  end

  def self.down
  end
end
