module Kanban
  class CardAdding

    def initialize(rule)
      @rule = rule
      @first_stage = rule.initial_stage
    end

    def next_stage
      @first_stage
    end

    def verify(board)
      first_phase_cards = board.count_card_on_phase(@first_stage.phase)
      raise WipLimitReached unless @rule.can_put_card?(@first_stage.phase, first_phase_cards)
    end
  end
end
