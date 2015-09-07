module Kanban
  class CardPulling

    def initialize(card, next_stage, rule)
      @card = card
      @next_stage = next_stage
      @rule = rule
    end

    def handle_board(board)
      next_phase_cards = board.count_card_on_phase(@next_stage.phase)
      raise WipLimitReached unless @rule.can_put_card?(@next_stage.phase, next_phase_cards)

      board.put_card(@card, @next_stage)
    end
  end
end
