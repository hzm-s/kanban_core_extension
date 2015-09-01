module Kanban
  class BoardBuilder

    def initialize(project_id)
      @project_id = project_id
      @stages = []
    end

    def add_stage(phase_spec)
      @stages << Stage.new(phase_spec.phase, phase_spec.wip_limit)
    end

    def board
      Board.new.tap do |board|
        board.project_id = @project_id
        board.stages = StageContainer.new(@stages)
      end
    end
  end
end
