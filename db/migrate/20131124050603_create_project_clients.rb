class CreateProjectClients < ActiveRecord::Migration
  def self.up
    create_table :project_clients do |t|
      t.column :project_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
  end

  def self.down
    drop tables :project_clients
  end
end
