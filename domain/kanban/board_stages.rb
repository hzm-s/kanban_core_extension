module Kanban
  class BoardStages

    def initialize(cards)
      @cards = cards
    end

    def retrieve(stage)
      BoardStage.new(stage, staged_cards(stage))
    end

    private
      # for AR::Association

      def staged_cards(stage)
        @cards.where(
          stage_phase_name: stage.phase.to_s,
          stage_state_name: stage.state.to_s
        )
      end
  end
end
