class CreateForumFields < ActiveRecord::Migration
  def self.up
  	add_column :forums, :project_id, :integer, references: :projects
  	add_column :forums, :classified, :string

  	create_table :forum_fields do |t|
  		t.references :forums
  		t.references :forum_classfieds
  		t.text :body
        		t.timestamps
  	end
  end

  def self.down
    drop_table :forum_fields
    remove_column :forums, :project_id
    remove_column :forums, :classified
  end
end
