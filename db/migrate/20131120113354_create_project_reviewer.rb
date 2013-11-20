class CreateProjectReviewer < ActiveRecord::Migration
  def self.up
	create_table :project_reviewers do |t|
      t.column :project_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :role_id, :integer, :null => true
  	end
  end

  def self.down
  end
end
