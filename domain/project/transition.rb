module Project
  class Transition

    def self.from_array(state_names)
      return None.new if Array(state_names).empty?
      states = state_names
                 .reject {|n| n.empty? }
                 .map {|n| State.new(n) }
      new(states)
    end

    def initialize(states)
      @states = states
    end

    def first
      @states.first
    end

    def next(state)
      @states[@states.index(state) + 1]
    end

    def last?(state)
      @states.last == state
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

      def first
        @state
      end

      def next(state)
        raise 'Transition::None'
      end

      def last?(state)
        true
      end

      def none?
        true
      end

      def to_a
        []
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
