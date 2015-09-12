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

    def change_wip_limit(phase, new_wip_limit, board)
      old_phase_spec = workflow.retrieve(phase)
      new_phase_spec = old_phase_spec.change_wip_limit(new_wip_limit, board)
      new_workflow = workflow.replace_phase(old_phase_spec, new_phase_spec)
      specify_workflow(new_workflow)
    end
  end
end
