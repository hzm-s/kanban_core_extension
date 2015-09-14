module Project
  class WorkflowBuilder
    attr_reader :workflow

    def initialize(old_workflow)
      @old_workflow = old_workflow
    end

    def add_phase_spec(new_phase_spec)
      @workflow = @old_workflow.add(new_phase_spec)
    end

    def insert_phase_spec_before(new_phase_spec, base_phase)
      base_phase_spec = @old_workflow.spec(base_phase)
      @workflow = @old_workflow.insert_before(new_phase_spec, base_phase_spec)
    end

    def insert_phase_spec_after(new_phase_spec, base_phase)
      next_spec_of_base_phase = @old_workflow.next(base_phase)
      return add_phase_spec(new_phase_spec) if next_spec_of_base_phase.last?
      insert_phase_spec_before(new_phase_spec, next_spec_of_base_phase.phase)
    end
  end
end
