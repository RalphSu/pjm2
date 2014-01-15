class CreateWeixinFields < ActiveRecord::Migration
  def self.up
    add_column :weixins, :classified, :string

    create_table :weixin_classifieds do |t|
      t.string :classified
      t.references :template

      t.timestamps
    end

    create_table :weixin_fields do |t|
  	t.references :weixins
  	t.references :weixin_classifieds
  	t.text :body
        t.timestamps
    end
  end

  def self.down
    drop_table :weixin_fields
    drop_table :weixin_classifieds
    remove_column :weixins, :classified
  end
end
