module Kanban
  class CardPushing

    def initialize(card, next_stage)
      @card = card
      @next_stage = next_stage
    end

    def handle_board(board)
      board.put_card(@card, @next_stage)
    end
  end
end
