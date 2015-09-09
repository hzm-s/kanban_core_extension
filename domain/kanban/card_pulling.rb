module Kanban
  class CardPulling

    def initialize(feature_id, from, to, rule)
      @feature_id = feature_id
      @from = from
      @to = to
      @rule = rule
    end

    def handle_board(board)
      to_phase_cards = board.count_card(@to.phase)
      raise WipLimitReached unless @rule.can_put_card?(@to.phase, to_phase_cards)

      board.put_card(@feature_id, @from, @to)
    end
  end
end
