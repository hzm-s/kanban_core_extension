module Kanban
  class CardPulling
    attr_reader :from_stage, :to_stage

    def initialize(from_stage, to_stage, rule)
      @from_stage = from_stage
      @to_stage = to_stage
      @rule = rule
    end

    def handle_board(feature_id, board)
      to_phase_cards = board.count_card_on_phase(@to_stage.phase)
      raise WipLimitReached unless @rule.can_put_card?(@to_stage.phase, to_phase_cards)

      card = board.fetch_card(feature_id, @from_stage)
      board.put_card(card, @to_stage)
    end
  end
end
