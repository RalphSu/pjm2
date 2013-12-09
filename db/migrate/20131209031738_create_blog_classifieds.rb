class CreateBlogClassifieds < ActiveRecord::Migration
  def self.up
    create_table :blog_classifieds do |t|
      t.string :classified
      t.references :template

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_classifieds
  end
end
