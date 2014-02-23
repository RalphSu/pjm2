#encoding: utf-8
class GlobalSetting < ActiveRecord::Base
	include Redmine::SafeAttributes

	safe_attributes 'name', 'value'
end
