module ReportTaskHelper

	def report_types(selected)
		types = [
			[l(:TYPE_DAILY), ReportTask::TYPE_DAILY],
			[l(:TYPE_WEEKLY), ReportTask::TYPE_WEEKLY],
			[l(:TYPE_SUMMARY),ReportTask::TYPE_SUMMARY]

		]
		options_for_select(types, selected)
	end

	def report_types_with_empty(selected)
		types = [
			["", ""],
			[l(:TYPE_DAILY), ReportTask::TYPE_DAILY],
			[l(:TYPE_WEEKLY), ReportTask::TYPE_WEEKLY],
			[l(:TYPE_SUMMARY),ReportTask::TYPE_SUMMARY]

		]
		options_for_select(types, selected)
	end

end
