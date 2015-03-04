module AdminHelper2Helper
  
  def index  
	Rails.logger.info "AdminHelper2Helper - index is called. Log for Frei"
  end
  
  def self.include(base)
    base.send.(:include, InstanceMethods)
  end
  
  module InstanceMethods
	def inactiveprojects
	  Rails.logger.info "inactiveprojects InstanceMethods is called. Log for Frei"
	
	  unless self.deliverable.nil?
        return self.deliverable.subject
      end
	end
  end
  
end

Rails.logger.info "AdminHelper2Helper is called. Log for Frei"
require 'admin_helper'
AdminHelper.send :include, AdminHelper2Helper
