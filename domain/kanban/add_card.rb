module Kanban
  class AddCard

    def initialize(feature_id, rule)
      @feature_id = feature_id
      @rule = rule
      @first_step = @rule.first_step
      @first_phase = @first_step.phase
    end

    def handle_board(board)
      first_phase_cards = board.count_card(@first_phase)
      raise WipLimitReached unless @rule.can_put_card?(@first_phase, first_phase_cards)

      board.add_card(@feature_id, @first_step)

      EventPublisher.publish(
        :card_added,
        CardAdded.new(board.project_id, @feature_id)
      )
    end
  end
end
