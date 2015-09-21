module Activity
  class PhaseNotFound < StandardError; end
  class DuplicatePhase < StandardError; end

  class WorkflowFactory

    def initialize(current_workflow = nil)
      @phase_specs = if current_workflow.nil?
                       []
                     else
                       current_workflow.to_a
                     end
    end

    def add_phase_spec(phase, transition, wip_limit)
      raise Activity::DuplicatePhase if @phase_specs.detect {|ps| ps.phase == phase }
      @phase_specs << PhaseSpec.new(phase, transition, wip_limit)
    end

    def insert_phase_spec_before(phase, transition, wip_limit, base_phase)
      raise Activity::DuplicatePhase if @phase_specs.detect {|ps| ps.phase == phase }
      raise Activity::PhaseNotFound unless @phase_specs.detect {|ps| ps.phase == base_phase }

      new_phase_spec = PhaseSpec.new(phase, transition, wip_limit)
      @phase_specs = @phase_specs.flat_map do |ps|
        ps.phase == base_phase ? [new_phase_spec, ps] : ps
      end
    end

    def insert_phase_spec_after(phase, transition, wip_limit, base_phase)
      raise Activity::DuplicatePhase if @phase_specs.detect {|ps| ps.phase == phase }
      raise Activity::PhaseNotFound unless @phase_specs.detect {|ps| ps.phase == base_phase }

      new_phase_spec = PhaseSpec.new(phase, transition, wip_limit)
      @phase_specs = @phase_specs.flat_map do |ps|
        ps.phase == base_phase ? [ps, new_phase_spec] : ps
      end
    end

    def build_workflow
      Workflow.new(@phase_specs)
    end
  end
end
