class AddNewsColoumn < ActiveRecord::Migration
  def self.up
  	add_column :news_releases, :project_id, :integer, references: :projects
  	add_column :news_releases, :classified, :string
  end

  def self.down
  	remove_column :news_releases, :project_id
  	remove_column :news_releases, :classified
  end
end
