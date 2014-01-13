class ReportTask < ActiveRecord::Base

	include Redmine::SafeAttributes

	safe_attributes 'status',
		'gen_start_time',
		'gen_end_time',
		'report_start_time',
		'report_end_time',
		'report_path',
		'gen_count'

	belongs_to :project
end
