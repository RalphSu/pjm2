class CreateWeiboClassifieds < ActiveRecord::Migration
  def self.up
    create_table :weibo_classifieds do |t|
      t.string :classified
      t.references :template

      t.timestamps
    end
  end

  def self.down
    drop_table :weibo_classifieds
  end
end
