class AddProjectKeywordsAny < ActiveRecord::Migration
  def self.up
  	  	add_column :projects, :keywords_any, :string
  end

  def self.down
  	  	remove_column :projects, :keywords_any
  end
end
