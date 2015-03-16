class InactiveprojectsController < ApplicationController
  layout 'admin'
    
  def index
	# Get the url parameter inactiveFor, if available
	if params[:inactiveFor]
      begin 
		@inactiveFor = params[:inactiveFor].to_i
	  rescue 
	    @inactiveFor = -1;
		Rails.logger.error "Exception: the url parameter [inactiveFor] could not converted to integer. The value is set to default: #{@inactiveFor}"
	  end
	else
	  @inactiveFor = -1;
	  Rails.logger.debug "No Url Parameter [inactiveFor] available: The value is set to default value: #{@inactiveFor}"
    end
					
	# Get all projects
    scope = Project.sorted
    @inactiveprojects = scope.to_a
	
	# Create the timespan of interested
	selectedTimespan = Date.today - @inactiveFor
	
	# Get all events in the desired timespan	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
	
    events = @activity.events(selectedTimespan , Date.today + 1)
	
	Rails.logger.debug "Projects: #{@inactiveprojects}"
	Rails.logger.debug "There are #{events.length} elements in the events array."
	Rails.logger.debug "Events: #{events}"
	Rails.logger.debug "There are #{@inactiveprojects.length} elements in the inactive projects array before filter."
	
	# Delete the project of each event in the timespan
	events.each do |item|
		@inactiveprojects.delete_if{|obj|obj.id == item.project.id}
	end
	
	# Delete all projects which are updated in the timespan
	@inactiveprojects.delete_if{|obj|obj.updated_on > (selectedTimespan)}
	
	Rails.logger.debug "There are #{@inactiveprojects.length} elements in the inactive projects array after filter."
  end
  
end