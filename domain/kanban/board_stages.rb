module Kanban
  class BoardStages

    def initialize(cards)
      @cards = cards
    end

    def fetch(feature_id, stage)
      fetch_card_from(feature_id, stage)
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

    def remove(card_record)
      @cards.destroy(card_record)
    end

    def count_card_by_phase(phase)
      @cards.where(stage_phase_name: phase.to_s).count
    end

    def fetch_card_from(feature_id, stage)
      @cards.where(
        feature_id_str: feature_id.to_s,
        stage_phase_name: stage.phase.to_s,
        stage_state_name: stage.state.to_s
      ).first
    end
  end
end
