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
	
	############## Events
	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
	
	Rails.logger.info "Event Abfrage ohne Fehler - Info for Frei"
	
	Rails.logger.info "Activity is: #{@activity}"
	
	#@activity.scope_select {|t| !params["show_#{t}"].nil?}
	#@activity.scope.include?(time_entries)
	
	
    #@activity.scope = (@author.nil? ? :default : :all) if @activity.scope.empty?

    events = @activity.events(Date.today - 2, Date.today + 1)
	
	Rails.logger.info "Events - Info for Frei - #{events}"
	
	
	
  end
end