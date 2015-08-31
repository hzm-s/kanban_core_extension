class ProjectService

  def initialize(project_repository)
    @project_repository = project_repository
  end

  def launch(description)
    factory = Project::ProjectFactory.new(@project_repository)
    project = factory.launch_project(description)

    @project_repository.store(project)

    project.project_id
  end
end
