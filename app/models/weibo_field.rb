class WeiboField < ActiveRecord::Base

	include Redmine::SafeAttributes

 	attr_accessor 'file_path'


	belongs_to :weibos, :class_name => "Weibo", :foreign_key => "weibos_id"
	belongs_to :weibo_classifieds, :class_name => "WeiboClassified", :foreign_key => "weibo_classifieds_id"
	safe_attributes 'body'

	validates_presence_of :weibos, :weibo_classifieds
end
