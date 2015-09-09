module Kanban
  class RemoveCard

    def initialize(feature_id, from)
      @feature_id = feature_id
      @from = from
    end

    def handle_board(board)
      board.remove_card(@feature_id, @from)

      EventPublisher.publish(
        :card_removed,
        CardRemoved.new(board.project_id, @feature_id)
      )
    end
  end
end
