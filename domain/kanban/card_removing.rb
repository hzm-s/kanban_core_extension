module Kanban
  class CardRemoving

    def initialize(card)
      @card = card
    end

    def handle_board(board)
      board.remove_card(@card)
    end
  end
end
