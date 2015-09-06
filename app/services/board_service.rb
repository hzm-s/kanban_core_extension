class BoardService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_card(project_id, feature_id)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    board.add_card(feature_id, rule)

    @board_repository.store(board)
  end

  def forward_card(project_id, feature_id, current_stage)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    board.forward_card(feature_id, current_stage, rule)

    @board_repository.store(board)
  end

  def can_add_card?(project_id)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    first_stage = rule.initial_stage
    rule.can_put_card?(first_stage.phase, board.staged_card(first_stage).size)
  end
end
