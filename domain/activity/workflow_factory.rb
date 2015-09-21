module Activity
  class PhaseNotFound < StandardError; end
  class CardOnPhase < StandardError; end

  class WorkflowFactory

    def initialize(current = nil)
      @phase_specs = current_phase_specs(current)
    end

    def add_phase_spec(phase, transition, wip_limit)
      @phase_specs << new_phase_spec(phase, transition, wip_limit)
    end

    def insert_phase_spec_before(phase, transition, wip_limit, base_phase)
      check_base_phase_exist!(base_phase)
      @phase_specs = @phase_specs.flat_map do |ps|
        if ps.phase == base_phase
          [new_phase_spec(phase, transition, wip_limit), ps]
        else
          ps
        end
      end
    end

    def insert_phase_spec_after(phase, transition, wip_limit, base_phase)
      check_base_phase_exist!(base_phase)

      next_phase_spec_of_base_phase = @phase_specs[@phase_specs.index {|ps| ps.phase == base_phase } + 1]
      return add_phase_spec(phase, transition, wip_limit) unless next_phase_spec_of_base_phase

      insert_phase_spec_before(
        phase, transition, wip_limit,
        next_phase_spec_of_base_phase.phase
      )
    end

    def remove_phase_spec(phase, board)
      raise CardOnPhase if board.any_card_on_phase?(phase)
      @phase_specs = @phase_specs.reject {|ps| ps.phase == phase }
    end

    def build_workflow
      Workflow.new(@phase_specs)
    end

    private

      def current_phase_specs(current)
        return [] unless current
        current.to_a
      end

      def new_phase_spec(phase, transition, wip_limit)
        PhaseSpec.new(phase, transition, wip_limit)
      end

      def check_base_phase_exist!(base_phase)
        raise PhaseNotFound unless @phase_specs.detect {|ps| ps.phase == base_phase }
      end
  end
end
