class CreateWeixins < ActiveRecord::Migration
  def self.up
    create_table :weixins do |t|
      t.references :projects
      t.timestamps
    end
  end

  def self.down
    drop_table :weixins
  end
end
