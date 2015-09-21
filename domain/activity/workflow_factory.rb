module Activity
  class PhaseNotFound < StandardError; end
  class CardOnPhase < StandardError; end
  class NeedPhaseSpec < StandardError; end

  class WorkflowFactory

    def initialize(current = nil)
      @phase_specs = current_phase_specs(current)
    end

    def add_phase_spec(phase_spec)
      @phase_specs << phase_spec
    end

    def insert_phase_spec_before(phase_spec, base_phase)
      check_phase_exist!(base_phase)
      @phase_specs = @phase_specs.flat_map do |ps|
        if ps.phase == base_phase
          [phase_spec, ps]
        else
          ps
        end
      end
    end

    def insert_phase_spec_after(phase_spec, base_phase)
      check_phase_exist!(base_phase)

      base_phase_index = @phase_specs.index {|ps| ps.phase == base_phase }
      next_phase_spec_of_base_phase = @phase_specs[base_phase_index + 1]
      return add_phase_spec(phase_spec) unless next_phase_spec_of_base_phase

      insert_phase_spec_before(phase_spec, next_phase_spec_of_base_phase.phase)
    end

    def remove_phase_spec(phase, board)
      check_phase_exist!(phase)
      raise NeedPhaseSpec if @phase_specs.size == 1
      raise CardOnPhase if board.any_card_on_phase?(phase)
      @phase_specs = @phase_specs.reject {|ps| ps.phase == phase }
    end

    def replace_phase_spec(phase_spec, old_phase)
      check_phase_exist!(old_phase)

      @phase_specs = @phase_specs.map do |ps|
        if ps.phase == old_phase
          phase_spec
        else
          ps
        end
      end
    end

    def build_workflow
      Workflow.new(@phase_specs)
    end

    private

      def current_phase_specs(current)
        return [] unless current
        current.to_a
      end

      def check_phase_exist!(base_phase)
        raise PhaseNotFound unless @phase_specs.detect {|ps| ps.phase == base_phase }
      end
  end
end
