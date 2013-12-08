class CreateNewsClassifieds < ActiveRecord::Migration
  def self.up
    create_table :news_classifieds do |t|
      t.string :classified
      t.references :template

      t.timestamps
    end
  end

  def self.down
    drop_table :news_classifieds
  end
end
