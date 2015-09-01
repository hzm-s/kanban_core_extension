class BoardService
  module EventHandler

    def workflow_specified(event)
      build_board(event.project_id, event.workflow)
    end
  end
  include EventHandler

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def build_board(project_id, workflow)
    builder = Kanban::BoardBuilder.new(project_id)
    board = workflow.build_board_with(builder)
    @board_repository.store(board)
  end

  def add_card(project_id, feature_id)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    rule = Kanban::Rule.new(project.workflow)
    locator = Kanban::Locator.new(project.workflow)
    board.add_card(feature_id, rule, locator)

    @board_repository.store(board)
  end

  def pull_card(project_id, feature_id, before, after)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    locator = Kanban::Locator.new(project.workflow)
    raise Project::OutOfWorkflow unless locator.valid_positions_for_pull?(before, after)

    rule = Kanban::Rule.new(project.workflow)
    board.pull_card(feature_id, before, after, rule)

    @board_repository.store(board)
  end

  def push_card(project_id, card, before, after)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    locator = Kanban::Locator.new(project.workflow)
    board.push_card(card, before, after, locator)

    @board_repository.store(board)
  end
end
