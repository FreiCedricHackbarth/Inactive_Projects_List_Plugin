#Encoding: UTF-8
require 'redmine'
require 'admin_menu_hooks'

Redmine::Plugin.register :inactive_projects_list_plugin do
  name 'Inactive Projects List Plugin'
  author 'Frei-Cedric Hackbarth'
  description 'The plugin provides a list of all projects, which are inactiv for a specific timespan.'
  version '0.0.8'
  url 'https://github.com/FreiCedricHackbarth/Inactive_Projects_List_Plugin.git'
  author_url 'https://github.com/FreiCedricHackbarth'
  requires_redmine :version_or_higher => '3.0.0'
  
  menu :admin_menu, :inactive_projects_list, { :controller => 'inactiveprojects', :action => 'index'}, :caption => :LabelInactiveProjects
end