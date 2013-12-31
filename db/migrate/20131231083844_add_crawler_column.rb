class AddCrawlerColumn < ActiveRecord::Migration
  def self.up
    add_column :crawler_jobs, :init_url, :string
  	add_column :crawler_jobs, :search_query_begin_date, :datetime
  	add_column :crawler_jobs, :search_query_end_date, :datetime
    add_column :news_releases, :crawler_id, :integer
  end

  def self.down
  	remove_column :crawler_jobs, :search_query_begin_date
  	remove_column :crawler_jobs, :search_query_end_date
  	remove_column :crawler_jobs, :add_news_ids
  end
end
