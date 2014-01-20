class ReportTask < ActiveRecord::Base

	include Redmine::SafeAttributes

	STATUS_PLANNED = 'planned'
	STATUS_INPROGRESS = 'inprogress'
	STATUS_GENERATED = 'generated'
	STATUS_REVIEWED = 'reviewed'
	STATUS_PUBLISHED = 'published'
	STATUS_CANCELPUBLISH ="cancelpublish"
	STATUS_LABEL = {
		STATUS_PLANNED => l(:STATUS_PLANNED),
		STATUS_INPROGRESS => l(:STATUS_INPROGRESS),
		STATUS_GENERATED => l(:STATUS_GENERATED),
		STATUS_REVIEWED => l(:STATUS_REVIEWED),
		STATUS_PUBLISHED => l(:STATUS_PUBLISHED),
		STATUS_CANCELPUBLISH => l(:STATUS_CANCELPUBLISH)
	}

	TYPE_DAILY="daily"
	TYPE_WEEKLY="weekly"
	TYPE_SUMMARY="summary"

	TYPE_LABEL = {
		TYPE_DAILY => l(:TYPE_DAILY),
		TYPE_WEEKLY => l(:TYPE_WEEKLY),
		TYPE_SUMMARY => l(:TYPE_SUMMARY)
	}

	safe_attributes 'status',
		'gen_start_time',
		'gen_end_time',
		'report_start_time',
		'report_end_time',
		'report_path',
		'reviewed_path',
		'gen_path',
		'type',
		'task_type',
		'gen_count'

	belongs_to :project

	def label_status
		STATUS_LABEL[self.status]
	end

	def label_type
		TYPE_LABEL[self.task_type]
	end
end
