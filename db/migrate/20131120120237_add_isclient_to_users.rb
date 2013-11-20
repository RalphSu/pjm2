class AddIsclientToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :client, :boolean
  end

  def self.down
    remove_column :users, :client
  end
end
