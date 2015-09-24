module Kanban
  class BoardMaintainer

    def initialize(board_repository)
      @board_repository = board_repository
    end

    def transition_setted(event)
      project_id = event.project_id
      new_phase_spec = event.new_phase_spec
      old_phase_spec = event.old_phase_spec

      board = @board_repository.find(event.project_id)
      board.move_all_card(old_phase_spec.first_step, new_phase_spec.first_step)
    end
  end
end
