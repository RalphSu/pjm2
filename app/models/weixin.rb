class Weixin < ActiveRecord::Base

	include Redmine::SafeAttributes

	belongs_to :project, :foreign_key=>"projects_id"

	safe_attributes 'classified'

	has_many :weixin_fields, :foreign_key => "weixins_id", :dependent => :delete_all


end
