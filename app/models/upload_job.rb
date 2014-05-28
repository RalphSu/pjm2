#-- encoding: UTF-8
class UploadJob < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'original_file_name', 
	"template", # weibo/news/...
	'total_count', 
	'succeed_count', 
	'status',
	"message",
	"submitter"

end
