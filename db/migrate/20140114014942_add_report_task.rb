class AddReportTask < ActiveRecord::Migration
  def self.up
  	add_column :report_tasks, :gen_path, :string
  	add_column :report_tasks, :reviewed_path, :string
  end

  def self.down
  	remove_column :report_tasks, :gen_path
  	remove_column :report_tasks, :reviewed_path
  end
end
