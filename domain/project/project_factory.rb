require 'securerandom'

module Project
  class ProjectFactory

    def initialize(project_repository)
      @project_repository = project_repository
    end

    def launch_project(description)
      ::Project::Project.new(generate_project_id, description)
    end

    private

      def generate_project_id
        ProjectId.new('prj_' + SecureRandom.uuid)
      end
  end
end
