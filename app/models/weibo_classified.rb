class WeiboClassified < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :template

	safe_attributes 'classified'

	has_many :weibo_fields
end
