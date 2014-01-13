class ReportTemplateController < ApplicationController
	layout 'content'

	before_filter :find_project_by_project_id

	verify :method => :post, :render => {:nothing => true, :status => :method_not_allowed }
	def save
		templates = params[:templates]
		templates = JSON.parse(templates)
		Rails.logger.info " Received templates definition : #{templates.inspect} !"
		unless templates.blank?
			# create all the templates, then replace the association from project the templates
			begin
				ActiveRecord::Base.transaction do
					new_templates = []
					templates.each { |param| 
						t = ReportTemplate.new
						t.template_type = param['template_type']
						t.classified = param['classified']
						t.position = param['position']
						t.project_id = param['project_id']
						t.save
						new_templates << t
					}

					# delete the old templates
					@project.report_templates = new_templates
				end
			rescue Exception => e
				Rails.logger.info e.inspect
			end
		end
		respond_to do |format|
       	 format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to({:controller => 'projects', :action => 'settings', :tab=>'report', :id=>@project.identifier})
      	  }
      	end
		
	end
end
