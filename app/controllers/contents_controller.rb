class ContentsController < ApplicationController
  layout 'content'
  
  before_filter :find_project_by_project_id, :except => [ :index, :show_image ]
  @show_project_main_menu=false

  def index
    @showall = params[:show] == "all"

    if User.current.employee?
      projects=User.current.active_projects
      if not @showall
        now = Time.now
        @projects = projects.select { | p |
          p.end_time.blank? or ((Time.local(p.end_time.year, p.end_time.month, p.end_time.day) <=> now) > 0)
        }
      else
        @projects = projects
      end
    else 
      @projects=User.current.active_client_projects
    end
    @p = @projects.first unless not @project.nil?
    @project = @p
    @category=params['category']
    @link = params[:link]
    @link_date = params[:link_date]

    Rails.logger.info "===========================================================#{request.protocol}#{request.host}:#{request.port}"
  end

  def project_content(project =nil)
    index
  end

  # show @project
  def show
    @category = params['category']
    @category = "" if @category.nil?
    @link = params[:link]
    @link_date = params[:link_date]
    @tab = params['tab'].nil? ? 'news' : params['tab']
    @p = Project.find(params[:project_id])
    @project = @p
    @projects=[]
    @projects << @p unless @p.nil?
  end

  def show_image
    imagepaths = params[:imagepaths]
    image_array = imagepaths.split(';')
    prefix = "/public"
    @image_url = []
    image_array.each do |i|
      if i.start_with?(prefix)
        @image_url << i.slice(prefix.size, i.size - prefix.size)
      else
        @image_url << i
      end
    end
    render :layout => false 
  end

end
