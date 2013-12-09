class CreateNewsReleases < ActiveRecord::Migration
  def self.up
    create_table :news_releases do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :news_releases
  end
end
