class BoardService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_card(project_id, feature_id)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    action = Kanban::CardAdding.new(feature_id, rule)
    board.update_with(action)

    @board_repository.store(board)
  end

  def forward_card(project_id, feature_id, current_stage)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    action = Kanban::CardForwarding.detect(feature_id, current_stage, rule)
    board.update_with(action)

    @board_repository.store(board)
  end
end
