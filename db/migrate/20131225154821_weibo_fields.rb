class WeiboFields < ActiveRecord::Migration
  def self.up
  	add_column :weibos, :project_id, :integer, references: :projects
  	add_column :weibos, :classified, :string

  	create_table :weibo_fields do |t|
  		t.references :weibos
  		t.references :weibo_classfieds
  		t.text :body
        t.timestamps
  	end
  end

  def self.down
  	remove_column :weibos, :project_id
  	remove_column :weibos, :classified
  	drop_table :weibo_fields
  end
end
