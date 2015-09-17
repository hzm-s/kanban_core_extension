module Kanban
  class CardMap

    def initialize(cards)
      @cards = cards
    end

    def add(card, to)
      add_item(card, to)
    end

    def update(card, to)
      card.relocate(to)
      update_item(card)
    end

    def remove(card)
      remove_item(card)
    end

    def fetch(feature_id, from)
      fetch_item_by_feature_id_and_step(feature_id, from)
    end

    def count_by_phase(phase)
      count_item_by_phase(phase)
    end

    def count_by_step(step)
      count_item_by_step(step)
    end

    private
      # for AR::Association

      def add_item(item, to)
        @cards.build(
          feature_id_str: item.feature_id.to_s,
          step_phase_name: to.phase.to_s,
          step_state_name: to.state.to_s
        )
      end

      def update_item(card)
        card.save!
      end

      def remove_item(item)
        @cards.destroy(item)
      end

      def count_item_by_phase(phase)
        @cards.where(step_phase_name: phase.to_s).count
      end

      def count_item_by_step(step)
        @cards.where(
          step_phase_name: step.phase.to_s,
          step_state_name: step.state.to_s
        ).count
      end

      def fetch_item_by_feature_id_and_step(feature_id, step)
        @cards.where(
          feature_id_str: feature_id.to_s,
          step_phase_name: step.phase.to_s,
          step_state_name: step.state.to_s
        ).first
      end
  end
end
