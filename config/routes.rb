
RedmineApp::Application.routes.draw do
  match 'inactiveprojects/index', :controller => 'inactiveprojects', :action => 'index', :via => [:get, :post]
  match 'inactiveprojects/archive', :controller=> 'inactiveprojects', :action => 'archiveProject', :via => [:get, :post]
  match 'inactiveprojects/unarchive', :controller=> 'inactiveprojects', :action => 'unarchiveProject', :via => [:get, :post]
end