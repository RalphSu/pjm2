class CreateGlobalSettings < ActiveRecord::Migration
  def self.up
    create_table :global_settings do |t|
      t.string :name
      t.string :value
      t.timestamps
    end

    add_index :global_settings, :name, :unique=>true
  end

  def self.down
    drop_table :global_settings
  end
end
