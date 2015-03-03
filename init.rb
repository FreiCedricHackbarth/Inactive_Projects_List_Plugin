#Encoding: UTF-8
Redmine::Plugin.register :inactive_projects_list_plugin do
  name 'Inactive Projects List Plugin'
  author 'Frei-Cedric Hackbarth'
  description 'The plugin provides a list of all projects, which are inactiv for a specific timespan.'
  version '0.0.1'
  url 'https://github.com/FreiCedricHackbarth/Inactive_Projects_List_Plugin.git'
  author_url 'https://github.com/FreiCedricHackbarth'
  menu :admin_menu, :AdminInactiveProjectsController, {}, :caption => 'Inactive Projects'
end

require_dependency 'WorkflowHelper2_helper'
#require_dependency 'AdminInactiveProjectsController'
