class ProjectService

  def initialize(project_repository, backlog_builder, board_builder)
    @project_repository = project_repository
    @backlog_builder = backlog_builder
    @board_builder = board_builder
  end

  def launch(description)
    EventPublisher.subscribe(@backlog_builder)

    factory = Project::ProjectFactory.new(@project_repository)
    project = factory.launch_project(description)
    @project_repository.store(project)

    EventPublisher.publish(
      :project_launched,
      Project::ProjectLaunched.new(project.project_id)
    )
    project.project_id
  end

  def specify_workflow(project_id, workflow)
    project = @project_repository.find(project_id)

    EventPublisher.subscribe(@board_builder)
    project.specify_workflow(workflow)

    @project_repository.store(project)
  end
end
