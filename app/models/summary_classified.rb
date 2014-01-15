class SummaryClassified < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :template

	safe_attributes 'classified'

	has_many :summary_fields

end
