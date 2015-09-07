module Kanban
  class CardPushing
    attr_reader :from_stage, :to_stage

    def initialize(feature_id, from_stage, to_stage)
      @feature_id = feature_id
      @from_stage = from_stage
      @to_stage = to_stage
    end

    def handle_board(board)
      raise CardNotFound unless card = board.fetch_card(@feature_id, @from_stage)
      board.put_card(card, @to_stage)
    end
  end
end
