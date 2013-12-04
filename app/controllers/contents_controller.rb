class ContentsController < ApplicationController
  def index
  	## TODO: get current users' projects
  	@projects = Project.all
  end

end
