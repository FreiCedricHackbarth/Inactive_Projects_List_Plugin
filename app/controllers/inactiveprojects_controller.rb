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
	
	# Get the url parameter inactivFor
	if params[:inactivFor]
      begin 
		@inactivFor = params[:inactivFor].to_i
	  rescue 
	    @inactivFor = 0;
		Rails.logger.info "Exception: inactivFor wird auf 0 gesetzt. #{@inactivFor}"
	  end
	else
	  @inactivFor = 0;
	  Rails.logger.info "Kein Url Parameter: inactivFor wird auf 0 gesetzt. #{@inactivFor}"
    end
	
	Rails.logger.info "Inactiv For Variable ist: #{@inactivFor}"
				
	# Get all projects
    scope = Project.sorted
    @inactivprojects = scope.to_a
	
	# Get all events in the desired timespan	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
		
    events = @activity.events(Date.today - @inactivFor , Date.today + 1)
	
	Rails.logger.info "Events: #{events}"
	Rails.logger.info "Es sind #{events.length} Elemente im Array Events."
	
	Rails.logger.info "Es sind #{@inactivprojects.length} Elemente vor dem Event Filter im Array Projekte."
	
	# Delete the project of each event in the timespan
	events.each do |item|
		#Rails.logger.info "Akitivtaet Nr #{item.project_id}"
		@inactivprojects = @inactivprojects.delete_if{|obj|obj.id == item.project_id}
	end
	
	Rails.logger.info "Es sind #{@inactivprojects.length} Elemente nach dem Event Filter im Array Projekte."
	
	####
    render :action => "projects", :layout => false if request.xhr?	
  end
  
end