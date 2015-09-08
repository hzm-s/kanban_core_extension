module Kanban
  class CardPushing

    def initialize(card, next_progress)
      @card = card
      @next_progress = next_progress
    end

    def handle_board(board)
      board.put_card(@card, @next_progress)
    end
  end
end
