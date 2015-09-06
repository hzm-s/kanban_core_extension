module Kanban
  class BoardStage
    attr_reader :cards

    def initialize(cards)
      @cards = cards
    end

    def add_card(card, rule)
      stage = rule.initial_stage
      raise WipLimitReached unless rule.can_put_card?(stage.phase, @cards.size)

      card.locate_to(stage, self)
    end

    # for AR::Association

    def put(card_record)
      if card_record.persisted?
        card_record.save!
      else
        @cards.build(
          feature_id_str: card_record.feature_id_str,
          stage_phase_name: card_record.stage_phase_name,
          stage_state_name: card_record.stage_state_name
        )
      end
    end
  end
end
