module Work
  class Work
    attr_reader :state

    def initialize(feature, state)
      @feature = feature
      @state = state
    end

    def to_a
      [@feature, @state]
    end

    def hash
      to_a.hash
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_a == other.to_a
    end
  end
end
