class CreateScreenshotJobs < ActiveRecord::Migration
  def self.up
    create_table :screenshot_jobs do |t|
    	t.integer :news_release_id,:null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :screenshot_jobs
  end
end
