module ServiceRegistry

  def project_service
    ProjectService.new(
      ProjectRepository.new,
      BoardRepository.new,
      Kanban::BoardBuilder.new(BoardRepository.new)
    )
  end

  def workflow_service
    WorkflowService.new(ProjectRepository.new, BoardRepository.new)
  end

  def wip_limit_service
    WipLimitService.new(ProjectRepository.new, BoardRepository.new)
  end

  def phase_spec_service
    PhaseSpecService.new(
      ProjectRepository.new,
      BoardRepository.new,
      Kanban::BoardMaintainer.new(BoardRepository.new)
    )
  end

  def feature_service
    FeatureService.new(FeatureRepository.new)
  end

  def board_service
    BoardService.new(
      ProjectRepository.new,
      BoardRepository.new,
      Feature::DevelopmentTracker.new(FeatureRepository.new)
    )
  end
end
