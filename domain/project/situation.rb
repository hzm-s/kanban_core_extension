module Project
  class Situation
    attr_reader :phase, :state

    def initialize(phase, state)
      @phase = phase
      @state = state
    end
  end
end
