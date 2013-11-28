class RemoveRoleAdminReviewer < ActiveRecord::Migration
  def self.up
  	remove_column :project_admins, :role_id
  	remove_column :project_reviewers, :role_id
  end

  def self.down
  	add_column :project_admins, :role_id, :integer, :null => false
  	add_column :project_reviewers, :role_id, :integer, :null => false
  end
end
