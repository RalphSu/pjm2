#-- encoding: UTF-8
#-- copyright
# ChiliProject is a project management system.
#
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class WelcomeController < ApplicationController
  caches_action :robots

  def index
  	::I18n.locale=:zh
    @news = News.latest User.current
    Rails.logger.info @news.size
    @projects = User.current.projects
  end

  def robots
  	::I18n.locale=:zh
    @projects = User.current.projects
    render :layout => false, :content_type => 'text/plain'
  end
end
