module Kanban
  class BoardBuilder

    def initialize(board_repository)
      @board_repository = board_repository
    end

    def project_launched(event)
      project_id = event.project.project_id

      return if @board_repository.find(project_id)
      board = prepare_board(project_id)
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
