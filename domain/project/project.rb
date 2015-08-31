module Project
  class Project
    attr_reader :project_id, :description, :workflow

    def initialize(project_id, description)
      @project_id = project_id
      @description = description
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
