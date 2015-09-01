require 'securerandom'

module Project
  class ProjectFactory

    def initialize(project_repository)
      @project_repository = project_repository
    end

    def launch_project(description)
      ::Project::Project.new.tap do |project|
        project.project_id = generate_project_id
        project.description = description
      end
    end

    private

      def generate_project_id
        ProjectId.new('prj_' + SecureRandom.uuid)
      end
  end
end
