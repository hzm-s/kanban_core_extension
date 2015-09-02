module ProjectCreator

  def Project(name, goal)
    description = Project::Description.new(name, goal)
    ProjectService().launch(description)
  end

  def ProjectService(
    project_repository: ProjectRepository.new,
    backlog_repository: FakeBacklogRepository.new,
    board_repository: BoardRepository.new
  )
    backlog_builder = Backlog::BacklogBuilder.new(backlog_repository)
    board_builder = Kanban::BoardBuilder.new(board_repository)

    ProjectService.new(
      project_repository,
      backlog_builder,
      board_builder
    )
  end
end
