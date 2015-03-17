class InactiveprojectsController < ApplicationController
  # Layout for the admin side menu
  layout 'admin'
  
  # Helper to get the issues
  include QueriesHelper
      
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
	
	Rails.logger.debug "Projects: #{@inactiveprojects}"
    Rails.logger.debug "There are #{@inactiveprojects.length} elements in the inactive projects array before filter."
	
	# Create the timespan of interested
	selectedTimespan = Date.today - @inactiveFor
	
	# Get all events in the desired timespan	
	@activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                             :with_subprojects => @with_subprojects,
                                                             :author => @author)
	
    events = @activity.events(selectedTimespan , Date.today + 1)
	
	Rails.logger.debug "Events: #{events}"
	Rails.logger.debug "There are #{events.length} elements in the events array."

	# Delete the project of each event in the timespan
	events.each do |item|
		@inactiveprojects.delete_if{|obj|obj.id == item.project.id}
	end
	
	# Delete all projects which are updated in the timespan
	@inactiveprojects.delete_if{|obj|obj.updated_on > (selectedTimespan)}
	
	# Get the issues and check the updated property of the issue is in the timespan.
	retrieve_query
	issuesList = @query.issues

	Rails.logger.debug "Issues: #{issuesList}"
	Rails.logger.debug "There are #{issuesList.length} elements in the issues array."
	
	# Delete the projects which had an issue which is updated in the timespan.	
	issuesList.each do |item|
		if item.updated_on > selectedTimespan
			Rails.logger.debug "The Issue #{item.id} is updated in the timespan. The issue is in the project: #{item.project.id}"
			@inactiveprojects.delete_if{|obj|obj.id == item.project.id}
		end
	end
		
	Rails.logger.debug "There are #{@inactiveprojects.length} elements in the inactive projects array after filter."
  end
  
  def archiveProject	
	# Get the projectId from the url parameter
	projectId = params[:projectId].to_i
	
	# Initialize the message for redirect_to
	message = l(:LabelTheProject) + " #{projectId} " + l(:LabelWasNotFound)
			
	# Get Projects
	projectList = Project.sorted.to_a
	
	# Search the project with the id
	projectList.each do |item|
		if item.id == projectId
			# archive the project
			unless item.archive
				flash[:error] = l(:error_can_not_archive_project)
			end
			message = l(:LabelTheProject) + " #{item} " + l(:LabelHasBeenArchived)
		end
	end
	
	redirect_to({ :action=>'index' }, :alert => message)
  end

  def unarchiveProject
  	# Get the projectId from the url parameter
	projectId = params[:projectId].to_i
	
	# Initialize the message for redirect_to
	message = l(:LabelTheProject) + " #{projectId} " + l(:LabelWasNotFound)
			
	# Get Projects
	projectList = Project.sorted.to_a
	
	# Search the project with the id
	projectList.each do |item|
		if item.id == projectId
			# unarchive the project
			unless item.unarchive
				flash[:error] = l(:error_can_not_archive_project)
			end
			message = l(:LabelTheProject) + " #{item} " + l(:LabelHasBeenUnarchived)
		end
	end
	
	redirect_to({ :action=>'index' }, :alert => message)
  end

end

