
RedmineApp::Application.routes.draw do
  match 'inactiveprojects/index', :controller => 'inactiveprojects', :action => 'index', :via => [:get, :post]
  match 'inactiveprojects/show', :controller => 'inactiveprojects', :action => 'show', :via => [:get, :post]
end