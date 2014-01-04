class ReportTemplateController < ApplicationController

	layout 'content'

	before_filter :find_project_by_project_id

	def show
	end

	verify :method => :post, :render => {:nothing => true, :status => :method_not_allowed }
	def save
	end
end
