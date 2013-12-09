class CreateForumClassifieds < ActiveRecord::Migration
  def self.up
    create_table :forum_classifieds do |t|
      t.string :classified
      t.references :template

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_classifieds
  end
end
