class ProjectService

  def initialize(project_repository)
    @project_repository = project_repository
  end

  def launch(name, goal)
    factory = Project::ProjectFactory.new(@project_repository)
    project = factory.launch_project(name, goal)

    @project_repository.store(project)

    project.project_id
  end
end
