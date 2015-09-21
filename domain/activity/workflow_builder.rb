module Activity
  class WorkflowBuilder
    attr_reader :workflow

    def initialize(old_workflow)
      @old_workflow = old_workflow
    end

    def set_transition(phase, transition)
      replace_workflow_with_phase(phase) do |old|
        old.set_transition(transition)
      end
    end

    def insert_state_before(phase, new, base_state)
      replace_workflow_with_phase(phase) do |old|
        old.insert_state_before(new, base_state)
      end
    end

    def insert_state_after(phase, new, base_state)
      base_step = Step.new(phase, base_state)
      next_step_of_base_state = @old_workflow.next_step(base_step)
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