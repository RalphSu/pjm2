class WeixinClassified < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :template

	safe_attributes 'classified'

	has_many :weixin_fields

end
