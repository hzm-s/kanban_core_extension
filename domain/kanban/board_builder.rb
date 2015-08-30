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
      Board.new(@project_id, StageContainer.new(@stages))
    end
  end
end
