class InactiveprojectsController < ApplicationController
  layout 'admin'
    
  def index
	# Get the url parameter inactiveFor, if available
	if params[:inactiveFor]
      begin 
		@inactiveFor = params[:inactiveFor].to_i
	  rescue 
	    @inactiveFor = -1;
		Rails.logger.info "Exception: inactiveFor is set to default value: #{@inactiveFor}"
	  end
	else
	  @inactiveFor = -1;
	  Rails.logger.info "No Url Parameter available: inactiveFor is set to default value: #{@inactiveFor}"
    end
					
	# Get all projects
    scope = Project.sorted
    @inactiveprojects = scope.to_a
	
	# Get all events in the desired timespan	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
		
    events = @activity.events(Date.today - @inactiveFor , Date.today + 1)
	
	Rails.logger.info "Projects: #{@inactiveprojects}"
	Rails.logger.info "There are #{events.length} elements in the events array."
	Rails.logger.info "Events: #{events}"
	Rails.logger.info "There are #{@inactiveprojects.length} elements in the inactiveprojects array before filter."
	
	# Delete the project of each event in the timespan
	events.each do |item|
		@inactiveprojects.delete_if{|obj|obj.id == item.project.id}
	end
	
	# Delete all projects which are updated in the timespan
	@inactiveprojects.delete_if{|obj|obj.updated_on > (Date.today - @inactiveFor)}
	
	Rails.logger.info "There are #{@inactiveprojects.length} elements in the inactiveprojects array after filter."
  end
  
end