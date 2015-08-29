module Work
  class Transition

    def initialize(states)
      @states = states
    end

    def first
      @states.first
    end
  end
end
