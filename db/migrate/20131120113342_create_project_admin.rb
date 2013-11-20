class CreateProjectAdmin < ActiveRecord::Migration
  def self.up
    create_table :project_admins do |t|
      t.column :project_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :role_id, :integer, :null => true
  	end
  end

  def self.down
  	drop_table :project_admin
  end
end
