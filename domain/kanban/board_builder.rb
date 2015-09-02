module Kanban
  class BoardBuilder

    def initialize(board_repository)
      @board_repository = board_repository
    end

    def workflow_specified(event)
      board = prepare_board(event.project_id)
      @board_repository.store(board)
    end

    private

      def prepare_board(project_id)
        Board.new.tap do |board|
          board.prepare(project_id)
        end
      end
  end
end
