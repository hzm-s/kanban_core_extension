module BoardCreator

  def BoardService(
    project_repository: ProjectRepository.new,
    board_repository: BoardRepository.new,
    development_tracker: Feature::DevelopmentTracker.new
  )
    BoardService.new(project_repository, board_repository, development_tracker)
  end
end
