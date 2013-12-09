class NewsReleaseFields < ActiveRecord::Migration
  def self.up
  	create_table :news_release_fields do |t|
  		t.references :news_releases
  		t.references :news_classfieds
  		t.text :body
  	end
  end

  def self.down
  	drop_table :news_release_fields
  end
end
