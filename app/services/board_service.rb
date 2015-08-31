class BoardService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_card(project_id, card)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    locator = Kanban::Locator.new(project.workflow)
    board.add_card(card, locator)

    @board_repository.store(board)
  end

  def pull_card(project_id, card, before, after)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    board.pull_card(card, before, after)

    @board_repository.store(board)
  end

  def push_card(project_id, card, before, after)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    board.push_card(card, before, after)

    @board_repository.store(board)
  end
end
