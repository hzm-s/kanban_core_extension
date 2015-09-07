module Kanban
  class CardRemoving

    def initialize(card)
      @card = card
    end

    def handle_board(board)
      board.remove_card(@card)

      EventPublisher.publish(
        :card_removed,
        CardRemoved.new(board.project_id, @card)
      )
    end
  end
end
