class SummaryField < ActiveRecord::Base

	include Redmine::SafeAttributes

	attr_accessor 'file_path'

	belongs_to :summaries, :class_name => "Summary", :foreign_key => "summaries_id"
	belongs_to :summary_classifieds, :class_name => "SummaryClassified", :foreign_key => "summary_classifieds_id"
	safe_attributes 'body'

	validates_presence_of :summaries, :summary_classifieds

end
