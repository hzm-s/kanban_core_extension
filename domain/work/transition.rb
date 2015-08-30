module Work
  class Transition

    def initialize(states)
      @states = states
    end

    def first
      @states.first
    end

    def next(state)
      next_index = @states.index(state) + 1
      @states[next_index]
    end
  end
end
