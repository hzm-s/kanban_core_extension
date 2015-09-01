class ProjectService

  def initialize(project_repository, board_builder)
    @project_repository = project_repository
    @board_builder = board_builder
  end

  def launch(description)
    factory = Project::ProjectFactory.new(@project_repository)
    project = factory.launch_project(description)

    @project_repository.store(project)

    project.project_id
  end

  def specify_workflow(project_id, workflow)
    project = @project_repository.find(project_id)

    EventPublisher.subscribe(@board_builder)
    project.specify_workflow(workflow)

    @project_repository.store(project)
  end
end
