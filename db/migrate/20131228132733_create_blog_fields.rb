class CreateBlogFields < ActiveRecord::Migration
  def self.up
  	add_column :blogs, :project_id, :integer, references: :projects
  	add_column :blogs, :classified, :string

  	create_table :blog_fields do |t|
  		t.references :blogs
  		t.references :blog_classfieds
  		t.text :body
        		t.timestamps
  	end
  end

  def self.down
    drop_table :blog_fields
    remove_column :blogs, :project_id
    remove_column :blogs, :classified
  end
end
