class ProjectManager
  class << self
    def get_project_for_user(project_id, user)
      if project=ProjectPermission.find_project_for_user(project_id, user)
        project
      else
        raise AccessDenied
      end
    end
  end
  
  def initialize(project_id, user)
    @project = self.class.get_project_for_user(project_id, user)
  end
  
end
