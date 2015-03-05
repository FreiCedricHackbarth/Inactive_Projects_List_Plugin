
RedmineApp::Application.routes.draw do
  match 'inactiveprojects/index', :controller => 'inactiveprojects', :action => 'index', :via => [:get, :post]
end