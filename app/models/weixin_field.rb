class WeixinField < ActiveRecord::Base

	include Redmine::SafeAttributes

	belongs_to :weixins, :class_name => "Weixin", :foreign_key => "weixins_id"
	belongs_to :weixin_classifieds, :class_name => "WeixinClassified", :foreign_key => "weixin_classifieds_id"
	safe_attributes 'body'

	validates_presence_of :weixins, :weixin_classifieds
end
