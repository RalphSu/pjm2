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

module RolesHelper

	def get_project_manager_role_id
		role = Role.find(:all, :conditions=>{:name=>'项目管理员'}).first
		role.id
	end

	def get_project_reviewer_role_id
		role = Role.find(:all, :conditions=>{:name=>'项目审核员'}).first
		role.id
	end
end
