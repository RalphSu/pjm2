class AlterReportTemplate < ActiveRecord::Migration
  def self.up
  	add_column :report_templates, :project_id, :integer, :null=>false
  	add_column :report_templates, :classified, :string, :null=>false
  	remove_column :report_templates, :classified_id
  end

  def self.down
  end
end
