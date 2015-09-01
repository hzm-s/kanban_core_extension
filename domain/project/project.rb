module Project
  class Project < ActiveRecord::Base
    include Arize::Project

    def specify_workflow(a_workflow)
      persist_workflow(a_workflow)

      EventPublisher.publish(
        :workflow_specified,
        WorkflowSpecified.new(project_id, a_workflow)
      )
    end

    # for AR::Base

    def project_id=(project_id)
      self.project_id_str = project_id.to_s
    end

    def description=(description)
      self.description_name = description.name.to_s
      self.description_goal = description.goal.to_s
    end

    def project_id
      ProjectId.new(project_id_str)
    end

    def description
      Description.new(description_name, description_goal)
    end

    def workflow
      build_workflow
    end
  end
end
