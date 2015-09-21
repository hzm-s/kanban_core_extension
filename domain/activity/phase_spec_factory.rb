module Activity
  class StateNotFound < StandardError; end

  class PhaseSpecFactory

    def initialize(current)
      @phase = current.phase
      @states = current.transition.to_a
      @wip_limit = current.wip_limit
    end

    def insert_state_before(state, base_state)
      check_state_exist!(base_state)

      @states = @states.flat_map do |s|
        s == base_state ? [state, s] : s
      end
    end

    def insert_state_after(state, base_state)
      check_state_exist!(base_state)

      @states = @states.flat_map do |s|
        s == base_state ? [s, state] : s
      end
    end

    def build_phase_spec
      PhaseSpec.new(@phase, build_transition, @wip_limit)
    end

    private

      def build_transition
        return NoTransition if @states.empty?
        Transition.new(@states)
      end

      def check_state_exist!(state)
        raise StateNotFound unless @states.include?(state)
      end
  end
end
