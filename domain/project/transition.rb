module Project
  class Transition
    include Enumerable

    def initialize(states)
      @states = states
    end

    def partial?(before_state, after_state)
      before_index = @states.index(before_state)
      @states[before_index + 1] == after_state
    end

    def first
      @states.first
    end
  end

  class Transition
    class None

      def first
        State::None.new
      end
    end
  end
end
