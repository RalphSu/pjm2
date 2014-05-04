# -*- encoding : utf-8 -*-
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

	def find_weibo_direct_file(task)
		prefix = File.join File.dirname(__FILE__), "../../"
		file_name = File.dirname(task.gen_path) +"/"+ task.id.to_s + "_微博直发.docx"
		weiboDirectFile = prefix + file_name
		if File.exists?(weiboDirectFile)
			return file_name
		end
	end
	def find_daren_direct_file(task)
		prefix = File.join File.dirname(__FILE__), "../../"
		file_name = File.dirname(task.gen_path) +"/"+ task.id.to_s + "_达人直发.docx"
		darenDirectFile = prefix + file_name
		if File.exists?(darenDirectFile)
			return file_name
		end
	end

end
