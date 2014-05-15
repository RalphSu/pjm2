class CreateUploadJobs < ActiveRecord::Migration
  def self.up
    create_table :upload_jobs do |t|
		t.string 'original_file_name', 
		t.string "template", # weibo/news/...
		t.integer 'total_count', 
		t.integer 'succeed_count', 
		t.string 'status' #
		t.timestamps
    end
  end

  def self.down
    drop_table :upload_jobs
  end
end
