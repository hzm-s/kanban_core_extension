module Kanban
  class CardMap

    def initialize(cards)
      @cards = cards
    end

    def fetch(feature_id, progress)
      fetch_card_by_feature_id_and_progress(feature_id, progress)
    end

    def remove(card)
      remove_card(card)
    end

    # for AR::Association

    def put(card_record)
      if card_record.persisted?
        card_record.save!
      else
        @cards.build(
          feature_id_str: card_record.feature_id_str,
          progress_phase_name: card_record.progress_phase_name,
          progress_state_name: card_record.progress_state_name
        )
      end
    end

    def count_card_by_phase(phase)
      @cards.where(progress_phase_name: phase.to_s).count
    end

    private

      def remove_card(card_record)
        @cards.destroy(card_record)
      end

      def fetch_card_by_feature_id_and_progress(feature_id, progress)
        @cards.where(
          feature_id_str: feature_id.to_s,
          progress_phase_name: progress.phase.to_s,
          progress_state_name: progress.state.to_s
        ).first
      end
  end
end
