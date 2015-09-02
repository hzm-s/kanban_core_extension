module Project
  class Project < ActiveRecord::Base
    include Arize::Project

    def specify_workflow(a_workflow)
      self.workflow = a_workflow

      EventPublisher.publish(
        :workflow_specified,
        WorkflowSpecified.new(project_id, a_workflow)
      )
    end
  end
end
