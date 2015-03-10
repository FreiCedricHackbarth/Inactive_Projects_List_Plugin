class InactiveprojectsController < ApplicationController
  layout 'admin'
    
  def index
	# Get the url parameter inactivFor, if available
	if params[:inactivFor]
      begin 
		@inactivFor = params[:inactivFor].to_i
	  rescue 
	    @inactivFor = 0;
		Rails.logger.info "Exception: inactivFor is set to default value: #{@inactivFor}"
	  end
	else
	  @inactivFor = 0;
	  Rails.logger.info "No Url Parameter available: inactivFor is set to default value: #{@inactivFor}"
    end
					
	# Get all projects
    scope = Project.sorted
    @inactivprojects = scope.to_a
	
	# Get all events in the desired timespan	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
		
    events = @activity.events(Date.today + 1 - @inactivFor , Date.today + 1)
	
	Rails.logger.info "Projects: #{@inactivprojects}"
	Rails.logger.info "There are #{events.length} elements in the events array."
	Rails.logger.info "Events: #{events}"
	Rails.logger.info "There are #{@inactivprojects.length} elements in the inactivprojects array before filter."
	
	# Delete the project of each event in the timespan
	events.each do |item|
		@inactivprojects.delete_if{|obj|obj.id == item.project.id}
				
		#if item.has_attribute?("project_id}")
		#	@inactivprojects.delete_if{|obj|obj.id == item.project_id}
		#elsif item.has_attribute?("journalized_id")
		#	@inactivprojects.delete_if{|obj|obj.id == item.journalized.project_id}
		#else
		#	Rails.logger.info "GenerischeLoesung: #{item.project}"
		#end
	end
	
	# Delete all projects which are updated in the timespan
	@inactivprojects.delete_if{|obj|obj.updated_on > (Date.today + 1 - @inactivFor)}
	
	Rails.logger.info "There are #{@inactivprojects.length} elements in the inactivprojects array after filter."
  end
  
end