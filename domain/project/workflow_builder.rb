module Project
  class WorkflowBuilder
    attr_reader :workflow

    def initialize(old_workflow)
      @old_workflow = old_workflow
    end

    def add_phase_spec(new)
      @workflow = @old_workflow.add(new)
    end

    def insert_phase_spec_before(new, base_phase)
      return add_phase_spec(new) unless base = @old_workflow.spec(base_phase)
      @workflow = @old_workflow.insert_before(new, base)
    end

    def insert_phase_spec_after(new, base_phase)
      return add_phase_spec(new) unless base = @old_workflow.spec(base_phase)
      next_spec_of_base_phase = @old_workflow.next_of(base)
      return add_phase_spec(new) if next_spec_of_base_phase.last?
      insert_phase_spec_before(new, next_spec_of_base_phase.phase)
    end
  end
end
