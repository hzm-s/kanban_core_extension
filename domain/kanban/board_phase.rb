module Kanban
  class BoardPhase

    def initialize(stage, cards)
      @stage = stage
      @cards = cards
    end

    def put_card(card)
      card.locate_to(@stage, self)
    end

    def card_size
      @cards.size
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
