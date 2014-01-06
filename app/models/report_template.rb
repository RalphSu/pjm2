class ReportTemplate < ActiveRecord::Base
	include Redmine::SafeAttributes

	#belong_to :project, :foreign_key=>'project_id'

	# manually maintianed the relationship between the template and the ***_classified
	safe_attributes 'template_type', 'classified', 'position'

end
