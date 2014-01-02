class CreateReportTemplate < ActiveRecord::Migration
  def self.up
    create_table :report_templates do |t|
		t.reference :project, :null => false
		t.string :template_type, :null => false
		t.column :classified_id, :integer, :null => false
		t.column :position, :integer, :null => false

		t.timestamps
    end
  end

  def self.down
  	drop_table :report_templates
  end

end
