class CrawlerJob < ActiveRecord::Base
	include Redmine::SafeAttributes

	safe_attributes "project_id", 
		"num_of_pages", 
		"saved_count", 
		"start_time", 
		"end_time",
		"search_query_begin_date",
		"search_query_end_date",
		"init_url"
end
