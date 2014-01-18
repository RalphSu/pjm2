class AddReportTaskType < ActiveRecord::Migration
  def self.up
  	add_column :report_tasks, :task_type, :string
  end

  def self.down
  end
end
