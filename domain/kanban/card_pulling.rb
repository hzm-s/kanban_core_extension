module Kanban
  class CardPulling

    def initialize(card, next_progress, rule)
      @card = card
      @next_progress = next_progress
      @rule = rule
    end

    def handle_board(board)
      next_phase_cards = board.count_card(@next_progress.phase)
      raise WipLimitReached unless @rule.can_put_card?(@next_progress.phase, next_phase_cards)

      board.put_card(@card, @next_progress)
    end
  end
end
