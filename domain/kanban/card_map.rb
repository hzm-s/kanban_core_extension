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

    def add(card, to)
      @cards.build(
        feature_id_str: card.feature_id.to_s,
        progress_phase_name: to.phase.to_s,
        progress_state_name: to.state.to_s
      )
    end

    def move(card, to)
      card.relocate(to)
      card.save!
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
