module Kanban
  class CardNotFound < StandardError; end

  class BoardStages

    def initialize(cards)
      @cards = cards
    end

    def fetch_card(feature_id, stage)
      fetch_card_from(feature_id, stage).tap do |card|
        raise CardNotFound unless card
      end
    end

    def put_card(card, to)
      card.locate_to(to, self)
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

    def count_card_on_phase(phase)
      @cards.where(stage_phase_name: phase.to_s).count
    end

    def fetch_card_from(feature_id, stage)
      @cards.where(
        feature_id_str: feature_id.to_s,
        stage_phase_name: stage.phase.to_s,
        stage_state_name: stage.state.to_s
      ).first
    end

    def card_on_stage(stage)
      @cards.where(
        stage_phase_name: stage.phase.to_s,
        stage_state_name: stage.state.to_s
      )
    end
  end
end
