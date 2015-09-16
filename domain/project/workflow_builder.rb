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

    def set_transition(phase, transition)
      replace_workflow_with_phase(phase) do |old|
        old.set_transition(transition)
      end
    end

    def add_state(phase, state)
      replace_workflow_with_phase(phase) do |old|
        old.add_state(state)
      end
    end

    def insert_state_before(phase, new, base_state)
      replace_workflow_with_phase(phase) do |old|
        old.insert_state_before(new, base_state)
      end
    end

    def insert_state_after(phase, new, base_state)
      base_step = Step.new(phase, base_state)
      return add_state(phase, new) unless @old_workflow.include_step?(base_step)

      next_step_of_base_state = @old_workflow.next_step(base_step)
      return add_state(phase, new) if next_step_of_base_state.complete?
      insert_state_before(phase, new, next_step_of_base_state.state)
    end

    private

      def replace_workflow_with_phase(phase)
        old = @old_workflow.spec(phase)
        new = yield(old)
        @workflow = @old_workflow.replace_with(old, new)
      end
  end
end
