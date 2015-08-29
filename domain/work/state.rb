module Work
  class State

    def initialize(state)
      @state = state
    end

    def to_s
      @state
    end

    def hash
      to_s.hash
    end

    def eql?
      self == other
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_s == other.to_s
    end
  end

  class State
    class None

      def ==(other)
        other.instance_of?(self.class)
      end
    end
  end
end
