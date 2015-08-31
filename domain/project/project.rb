module Project
  class Project
    attr_reader :project_id, :name, :goal, :workflow

    def initialize(project_id, name, goal)
      @project_id = project_id
      @name = name
      @goal = goal
      @workflow = nil
    end

    def specify_workflow(workflow)
      @workflow = workflow
    end

    def build_board
      @workflow.build_board_with(Kanban::BoardBuilder.new(@project_id))
    end
  end
end
