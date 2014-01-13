class CreateReportTasks < ActiveRecord::Migration
  def self.up
	create_table :report_tasks do |t|
		t.integer :project_id,:null=>false
		t.string :status
		t.datetime :gen_start_time
		t.datetime :gen_end_time
		t.datetime :report_start_time
		t.datetime :report_end_time
		t.string :report_path
		t.integer :gen_count
		t.timestamps
	end
  end

  def self.down
	drop_table :report_tasks
  end
end
