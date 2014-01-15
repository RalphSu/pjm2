class Summary < ActiveRecord::Base

	include Redmine::SafeAttributes

	belongs_to :project, :foreign_key=>'projects_id'

	safe_attributes 'classified'

	has_many :summary_fields, :foreign_key => "summaries_id"

end
