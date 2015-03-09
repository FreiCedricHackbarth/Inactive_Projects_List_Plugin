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
    #scope = scope.like(params[:name]) if params[:name].present?
    @inactivprojects = scope.to_a

    render :action => "projects", :layout => false if request.xhr?

	Rails.logger.info "scope is: #{scope}"
	Rails.logger.info "projects is: #{@inactivprojects}"
	
	Rails.logger.info "Es sind #{@inactivprojects.length} Elemente im Array Projekte."
	
	############## Events
	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
	
	Rails.logger.info "Event Abfrage ohne Fehler - Info for Frei"
	
	Rails.logger.info "Activity is: #{@activity}"
	
    events = @activity.events(Date.today - 20, Date.today + 1)
	
	Rails.logger.info "Events - Info for Frei - #{events}"
	
	Rails.logger.info "Es sind #{events.length} Elemente im Array Events."
	
	events.each do |item|
		Rails.logger.info "Akitivtaet Nr #{item.project_id}"
		@inactivprojects = @inactivprojects.delete_if{|obj|obj.id == item.project_id}
	end
	
	Rails.logger.info "Es sind #{@inactivprojects.length} Elemente im Array Projekte."
	
  end
end