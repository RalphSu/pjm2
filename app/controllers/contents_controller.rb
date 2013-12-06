class ContentsController < ApplicationController

  def index
  	## TODO: get current users' projects
  	@projects = Project.all
  end

  def news
  end

  def weibo
  end

  def project_content(porject)
  end

end
