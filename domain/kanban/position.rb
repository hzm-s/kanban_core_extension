module Kanban
  class Position
    attr_reader :phase, :state

    def initialize(phase, state)
      @phase = phase
      @state = state
    end

    def to_a
      [@phase, @state]
    end

    def same_phase?(other)
      self.to_a[0] == other.to_a[0]
    end

    def eql?(other)
      self == other
    end

    def hash
      to_a.hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_a == other.to_a
    end
  end
end
