module Kanban
  class PullCard

    def initialize(feature_id, from, to, workflow)
      @feature_id = feature_id
      @from = from
      @to = to
      @to_phase_spec = workflow.spec(@to.phase)
    end

    def handle_board(board)
      to_phase_cards = board.count_card(@to.phase)
      raise Activity::WipLimitReached if @to_phase_spec.reach_wip_limit?(to_phase_cards)

      board.move_card(@feature_id, @from, @to)
    end
  end
end
