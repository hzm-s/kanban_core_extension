module Kanban
  class BoardStages

    def initialize(cards)
      @cards = cards
    end

    def as_stage(stage)
      BoardStage.new(stage, fetch_card_by_stage(stage))
    end

    def as_phase(stage)
      BoardPhase.new(stage, fetch_card_by_phase(stage.phase))
    end

    private
      # for AR::Association

      def fetch_card_by_stage(stage)
        @cards.where(
          stage_phase_name: stage.phase.to_s,
          stage_state_name: stage.state.to_s
        )
      end

      def fetch_card_by_phase(phase)
        @cards.where(stage_phase_name: phase.to_s)
      end
  end
end
