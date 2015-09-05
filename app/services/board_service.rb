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

  def pull_card(project_id, feature_id, from, to)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    board.pull_card(feature_id, from, to, rule)

    @board_repository.store(board)
  end

  def push_card(project_id, feature_id, from, to)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    board.push_card(feature_id, from, to, rule)

    @board_repository.store(board)
  end

  def can_add_card?(project_id)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    first_phase = rule.initial_position.phase

    rule.can_put_card?(first_phase, board.count_card_by_phase(first_phase))
  end
end
