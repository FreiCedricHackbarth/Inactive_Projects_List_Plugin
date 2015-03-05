class AdminMenuHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = { })
    stylesheet_link_tag('inactiveprojects.css', :plugin => 'inactive_projects_list_plugin')
  end
end
