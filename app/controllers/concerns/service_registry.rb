module ServiceRegistry

  def project_service
    ProjectService.new(
      ProjectRepository.new,
      Kanban::BoardBuilder.new(BoardRepository.new)
    )
  end

  def feature_service
    FeatureService.new(FeatureRepository.new)
  end

  def board_service
    BoardService.new(ProjectRepository.new, BoardRepository.new)
  end
end
