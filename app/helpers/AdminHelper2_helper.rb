module AdminHelper2Helper
  
  def inactiveprojects()   
  
	Rails.logger.info "AdminHelper2Helper is called. Log for Frei"
	
  end
  
  def projects
	Rails.logger.info "AdminInactiveProjectsController - projects is called. Log for Frei"
  
    @status = params[:status] || 1

    scope = Project.status(@status).sorted
    scope = scope.like(params[:name]) if params[:name].present?
    @projects = scope.to_a

    render :action => "projects", :layout => false if request.xhr?
  end

end

Rails.logger.info "AdminHelper2Helper is called. Log for Frei"
require 'admin_helper'
AdminHelper.send :include, AdminHelper2Helper
