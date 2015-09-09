module Kanban
  class CardPushing

    def initialize(feature_id, from, to)
      @feature_id = feature_id
      @from = from
      @to = to
    end

    def handle_board(board)
      board.put_card(@feature_id, @from, @to)
    end
  end
end
