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

module PjmMenuHelper

  # Renders the contents main menu.
  def render_content_menu(project)
    render_menu(:content_menu, project)
  end

  def render_menu_button(node, project=nil)
    if node.nil?
      return
    end
    caption, url, selected = extract_node_details(node, project)
    
    Rails.logger.info selected

    Rails.logger.info node.name
    html = [].tap do |html|
    html << '<li class="btn btn-outline-inverse btn-shadow  ">'
    if not selected.nil? and selected
       selectedcss = node.name.to_s+"selected"
        Rails.logger.info selectedcss
         selectedhtml_options = { :class => selectedcss }
        html <<link_to("",url, node.html_options.merge(selectedhtml_options))
    else
       html <<link_to("",url, node.html_options(:selected => selected))
    end

    html << '</li>'
    end
    return html.join("\n")
  end
end
