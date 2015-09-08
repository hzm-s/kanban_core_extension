class CardNotFound < StandardError; end

class BoardService

  def initialize(project_repository, board_repository, development_tracker)
    @project_repository = project_repository
    @board_repository = board_repository
    @development_tracker = development_tracker
  end

  def add_card(project_id, feature_id)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    action = Kanban::CardAdding.new(feature_id, rule)
    board.update_with(action)

    @board_repository.store(board)
  end

  def forward_card(project_id, feature_id, current_progress)
    EventPublisher.subscribe(@development_tracker)

    board = @board_repository.find(project_id)
    raise CardNotFound unless card = board.fetch_card(feature_id, current_progress)

    project = @project_repository.find(project_id)
    rule = Kanban::Rule.new(project.workflow)

    action = Kanban::CardForwarding.detect(card, rule)
    board.update_with(action)

    @board_repository.store(board)
  end
end
