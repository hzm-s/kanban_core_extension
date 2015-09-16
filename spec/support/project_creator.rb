module ProjectCreator

  def Project(name, goal)
    description = Project::Description.new(name, goal)
    ProjectService().launch(description)
  end

  def ProjectService(project_repository: ProjectRepository.new, board_repository: BoardRepository.new)
    board_builder = Kanban::BoardBuilder.new(board_repository)
    ProjectService.new(project_repository, board_repository, board_builder)
  end

  def ProjectId(str)
    Project::ProjectId.new(str)
  end
end
