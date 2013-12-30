class CreateCrawlerJobs < ActiveRecord::Migration
  def self.up
	# crawler job status : projectId, star_time, end_time, num_of_pages_read, num_of_items_added

    create_table :crawler_jobs do |t|
      	t.column :project_id, :integer, :default => 0, :null => false
      	t.column :num_of_pages, :integer
      	t.column :saved_count, :integer 
      	t.column :start_time, :string 
      	t.column :end_time, :string
         t.timestamps
    end
  end

  def self.down
    drop_table :crawler_jobs
  end
end
