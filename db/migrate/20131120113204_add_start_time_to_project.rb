class AddStartTimeToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :start_time, :date
  end

  def self.down
    remove_column :projects, :start_time
  end
end
