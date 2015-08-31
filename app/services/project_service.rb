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

  def specify_workflow(project_id, workflow)
    project = @project_repository.find(project_id)

    project.specify_workflow(workflow)

    @project_repository.store(project)
  end
end
