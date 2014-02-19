class Summary < ActiveRecord::Base

	include Redmine::SafeAttributes

	belongs_to :project, :foreign_key=>'projects_id'

	safe_attributes 'classified', 'image_date', 'url'

	has_many :summary_fields, :foreign_key => "summaries_id", :dependent => :delete_all

end
