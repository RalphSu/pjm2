class CreateSummaryFields < ActiveRecord::Migration
  def self.up
    add_column :summaries, :classified, :string

    create_table :summary_classifieds do |t|
      t.string :classified
      t.references :template

      t.timestamps
    end

    create_table :summary_fields do |t|
  	t.references :summaries
  	t.references :summary_classifieds
  	t.text :body
        t.timestamps
    end
  end

  def self.down
    drop_table :summary_fields
    drop_table :summary_classifieds
    remove_column :summaries, :classified
  end
end
