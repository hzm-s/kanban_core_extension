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

      card = Card.write(@feature_id)
      board.put_card(card, @first_progress)

      EventPublisher.publish(
        :card_added,
        CardAdded.new(board.project_id, card)
      )
    end
  end
end
