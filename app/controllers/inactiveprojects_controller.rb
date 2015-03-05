class InactiveprojectsController < ApplicationController
  layout 'admin'
  menu_item :projects, :only => :projects
  menu_item :plugins, :only => :plugins
  menu_item :info, :only => :info

  before_filter :require_admin
  helper :sort
  include SortHelper
  
  def index
	Rails.logger.info "The function index of InactiveprojectsController was called. Info for Frei"
		
	#@status = params[:status] || 1
	#Status 1 Active
	#Status 5 Closed
	#Status 9 Archived

    scope = Project.sorted
    scope = scope.like(params[:name]) if params[:name].present?
	#scope = scope.like('03.03.2015')
    @projects = scope.to_a

    render :action => "projects", :layout => false if request.xhr?
	
	Rails.logger.info "status is: #{@status}"
	Rails.logger.info "scope is: #{scope}"
	Rails.logger.info "projects is: #{@projects}"
  end
end