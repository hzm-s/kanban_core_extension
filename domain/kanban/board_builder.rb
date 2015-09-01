module Kanban
  class BoardBuilder

    def initialize(project_id)
      @project_id = project_id
      #@stages = []
    end

    def add_stage(phase_spec)
      #@stages << Stage.new(phase_spec.phase, phase_spec.wip_limit)
    end

    def board
      Board.new.tap do |board|
        board.prepare(@project_id)
      end
    end
  end
end
