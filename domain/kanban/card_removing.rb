module Kanban
  class CardRemoving
    attr_reader :from_stage, :to_stage

    def initialize(from_stage, to_stage)
      @from_stage = from_stage
      @to_stage = to_stage
    end

    def handle_board(feature_id, board)
      card = board.fetch_card(feature_id, @from_stage)
      board.remove_card(card)
    end
  end
end
