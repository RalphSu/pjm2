class AddReportTask1 < ActiveRecord::Migration
  def self.up
  	add_column :report_tasks, :type, :string
  end

  def self.down
  	remove_column :report_tasks, :type
  end
end
