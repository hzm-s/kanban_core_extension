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

      EventPublisher.publish(
        :workflow_specified,
        WorkflowSpecified.new(@project_id, @workflow)
      )
    end
  end
end
