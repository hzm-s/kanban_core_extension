module Kanban
  class CardAdding

    def initialize(feature_id, rule)
      @feature_id = feature_id
      @rule = rule
    end

    def handle_board(board)
      first_phase_cards = board.count_card(first_progress.phase)
      raise WipLimitReached unless @rule.can_put_card?(first_progress.phase, first_phase_cards)

      card = Card.write(@feature_id)
      board.put_card(card, first_progress)
    end

    private

      def first_progress
        @first_progress ||= @rule.first_progress
      end
  end
end
