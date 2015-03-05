
RedmineApp::Application.routes.draw do
  match 'inactiveprojects/index', :controller => 'inactiveprojects', :action => 'index', :via => [:get, :post]
  
  match 'logs/index', :controller => 'logs', :action => 'index', :via => [:get, :post]
  match 'logs/show', :controller => 'logs', :action => 'show', :via => [:get, :post]
  match 'logs/download', :controller => 'logs', :action => 'download', :via => [:get, :post]
  match 'logs/delete', :controller => 'logs', :action => 'delete', :via => [:get, :post]
end