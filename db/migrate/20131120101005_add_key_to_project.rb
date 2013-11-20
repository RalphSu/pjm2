class AddKeyToProject < ActiveRecord::Migration
  def self.up
  	add_column :projects, :keywords, :string
  	add_column :projects, :keywords_except, :string
  	add_column :projects, :end_time, :date
  end

  def self.down
  	remove_column :projects, :key
  	remove_column :projects, :key_except
  	remove_column :projects, :end_time
  end
end
