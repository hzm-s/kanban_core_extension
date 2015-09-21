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

    private

      def replace_workflow_with_phase(phase)
        old = @old_workflow.spec(phase)
        new = yield(old)
        @workflow = @old_workflow.replace_with(old, new)
      end
  end
end
