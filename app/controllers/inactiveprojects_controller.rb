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
		
	@status = params[:status] || 1

    scope = Project.status(@status).sorted
    scope = scope.like(params[:name]) if params[:name].present?
    @projects = scope.to_a

    render :action => "projects", :layout => false if request.xhr?
	
	
	
    #scope = Project
    #scope = scope.like(params[:name]) if params[:name].present?
    #@projects = scope
	
	#Rails.logger.info "scope is: #{scope}"
	Rails.logger.info "projects is: #{@projects}"

    #render :action => "projects", :layout => false if request.xhr?
	
  end

end