class ProjectService

  def initialize(project_repository, board_service)
    @project_repository = project_repository
    @board_service = board_service
  end

  def launch(description)
    factory = Project::ProjectFactory.new(@project_repository)
    project = factory.launch_project(description)

    @project_repository.store(project)

    project.project_id
  end

  def specify_workflow(project_id, workflow)
    project = @project_repository.find(project_id)

    EventPublisher.subscribe(@board_service)
    project.specify_workflow(workflow)

    @project_repository.store(project)
  end
end
