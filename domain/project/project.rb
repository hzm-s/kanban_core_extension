module Project
  class Project < ActiveRecord::Base

    def specify_workflow(workflow)
      set_workflow(workflow)

      EventPublisher.publish(
        :workflow_specified,
        WorkflowSpecified.new(@project_id, workflow)
      )
    end

    # ARize

    self.table_name = 'project_records'
    has_many :phase_spec_records
    has_many :state_records

    def project_id=(project_id)
      self.project_id_str = project_id.to_s
    end

    def description=(description)
      self.description_name = description.name.to_s
      self.description_goal = description.goal.to_s
    end

    def set_workflow(workflow)
      workflow.arize(self)
    end

    def project_id
      ProjectId.new(project_id_str)
    end

    def description
      Description.new(description_name, description_goal)
    end

    def workflow
      Workflow.modelize(phase_spec_records, state_records)
    end
  end
end
