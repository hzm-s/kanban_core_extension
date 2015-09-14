module Project
  class WorkflowBuilder
    attr_reader :workflow

    def initialize(old_workflow)
      @old_workflow = old_workflow
    end

    def add_phase_spec(new_phase_spec, position = {})
      direction, phase = position.flatten
      return add_phase_spec_before(new_phase_spec, phase) if direction == :before
      return add_phase_spec_after(new_phase_spec, phase) if direction == :after
      add_phase_spec_to_tail(new_phase_spec)
    end

    def add_phase_spec_to_tail(new_phase_spec)
      @workflow = @old_workflow.add(new_phase_spec)
    end

    def add_phase_spec_before(new_phase_spec, phase)
      new_phase_specs = @old_workflow.to_a.map do |phase_spec|
        if phase_spec.phase == phase
          [new_phase_spec, phase_spec]
        else
          phase_spec
        end
      end
      @workflow = Workflow.new(new_phase_specs.flatten)
    end

    def add_phase_spec_after(new_phase_spec, phase)
      next_spec_of_after_phase = @old_workflow.next(phase)
      add_phase_spec_before(new_phase_spec, next_spec_of_after_phase.phase)
    end
  end
end
