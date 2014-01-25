class Weibo < ActiveRecord::Base
	include Redmine::SafeAttributes

	belongs_to :project

	safe_attributes 'classified'

	has_many :weibo_fields, :foreign_key => "weibos_id", :dependent => :delete_all

end
