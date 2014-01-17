class PjconfigController < ApplicationController
layout 'pjconfig'

  def index
  end


 def projects
      if User.current.admin
        @status = params[:status] ? params[:status].to_i : 1
        c = ARCondition.new(@status == 0 ? "status <> 0" : ["status = ?", @status])

        unless params[:name].blank?
          name = "%#{params[:name].strip.downcase}%"
          c << ["LOWER(identifier) LIKE ? OR LOWER(name) LIKE ?", name, name]
        end

        @projects = Project.find :all, :order => 'lft', :conditions => c.conditions
      else
         @status = params[:status] ? params[:status].to_i : 1
         @projects = []
         User.current.active_projects.each do |p|
            if @status == 0
              @projects <<p
            else
              @projects << p if p.status == @status
            end
         end
      end

    Rails.logger.info "User is : #{User.current}, projects are #{User.current.active_projects} ! ! !"
    render :action => "projects", :layout => false if request.xhr?
  end
end
