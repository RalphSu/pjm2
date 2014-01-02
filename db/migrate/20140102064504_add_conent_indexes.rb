class AddConentIndexes < ActiveRecord::Migration

  def self._catch()
  	begin
  		yield
  	rescue Exception => e
  		puts "migration with exception #{e.inspect}"
  	end
  end

  def self.up
  	# add column for news_release only - the timestamps was missed
  	_catch() { add_column :news_release_fields, :created_at, :timestamp }
  	_catch() { add_column :news_release_fields, :updated_at, :timestamp }
  	_catch() { rename_column :news_release_fields, :news_classfieds_id, :news_classifieds_id }
  	_catch() { rename_column :weibo_fields, :weibo_classfieds_id, :weibo_classifieds_id }
  	_catch() { rename_column :blog_fields, :blog_classfieds_id, :blog_classifieds_id }
  	_catch() { rename_column :forum_fields, :forum_classfieds_id, :forum_classifieds_id}

  	# add indexes for content line items
  	_catch() { add_index :news_releases, [:project_id, :classified] }
  	_catch() { add_index :weibos, [:project_id, :classified] }
  	_catch() { add_index :blogs, [:project_id, :classified] }
  	_catch() { add_index :forums, [:project_id, :classified] }

  	# add index on fields tables
  	#	a. add indexes for table ***_fields on column ***_classifieds_id
	_catch() { add_index :news_release_fields, :news_classifieds_id }
	_catch() { add_index :weibo_fields, :weibo_classifieds_id }
	_catch() { add_index :blog_fields, :blog_classifieds_id }
	_catch() { add_index :forum_fields, :forum_classifieds_id }

	# 	b. add indexes for table ***_fields on column ***_id
	_catch() { add_index :news_release_fields, :news_releases_id }
	_catch() { add_index :weibo_fields, :weibos_id }
	_catch() { add_index :blog_fields, :blogs_id }
	_catch() { add_index :forum_fields, :forums_id }
  end

  def self.down
  end
end
