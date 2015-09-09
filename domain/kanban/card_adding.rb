module Kanban
  class CardAdding

    def initialize(feature_id, rule)
      @feature_id = feature_id
      @rule = rule
      @first_progress = @rule.first_progress
      @first_phase = @first_progress.phase
    end

    def handle_board(board)
      first_phase_cards = board.count_card(@first_phase)
      raise WipLimitReached unless @rule.can_put_card?(@first_phase, first_phase_cards)

      board.add_card(@feature_id, @first_progress)
    end
  end
end
