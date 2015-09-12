module Kanban
  class AddCard

    def initialize(feature_id, workflow)
      @feature_id = feature_id
      @first_phase_spec = workflow.first
    end

    def handle_board(board)
      first_phase_cards = board.count_card(@first_phase_spec.phase)
      raise Project::WipLimitReached if @first_phase_spec.reach_wip_limit?(first_phase_cards)

      board.add_card(@feature_id, @first_phase_spec.first_step)

      EventPublisher.publish(
        :card_added,
        CardAdded.new(board.project_id, @feature_id)
      )
    end
  end
end
