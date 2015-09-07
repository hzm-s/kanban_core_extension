module Kanban
  class CardAdding

    def initialize(feature_id, rule)
      @feature_id = feature_id
      @rule = rule
    end

    def handle_board(board)
      first_phase_cards = board.count_card(first_stage.phase)
      raise WipLimitReached unless @rule.can_put_card?(first_stage.phase, first_phase_cards)

      card = Card.write(@feature_id)
      board.put_card(card, first_stage)
    end

    private

      def first_stage
        @first_stage ||= @rule.initial_stage
      end
  end
end
