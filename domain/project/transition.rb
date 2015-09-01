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

    def none?
      false
    end

    def to_a
      @states
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

  class Transition
    class None

      def initialize
        @state = State::None.new
      end

      def none?
        true
      end

      def first
        @state
      end

      def eql?(other)
        self == other
      end

      def hash
        nil.hash
      end

      def ==(other)
        other.instance_of?(self.class)
      end
    end
  end
end
