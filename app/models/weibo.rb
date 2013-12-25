class Weibo < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified'

	has_many :weibo_fields

end
