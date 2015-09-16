module Project
  class StateNotFound < StandardError; end
  class DuplicateState < StandardError; end

  class Transition

    def self.from_array(state_names)
      return None.new if Array(state_names).empty?
      states = state_names
                 .reject {|n| n.empty? }
                 .map {|n| State.new(n) }
      new(states)
    end

    def initialize(states)
      set_states(states)
    end

    def insert_before(new, base)
      return add_state(new) if base.complete?

      new_states = @states.map do |state|
        state == base ? [new, state] : state
      end
      self.class.new(new_states.flatten)
    end

    def first
      @states.first
    end

    def next(state)
      @states[@states.index(state) + 1]
    end

    def include?(state)
      return true if state.complete?
      @states.include?(state)
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

    private

      def set_states(states)
        raise ArgumentError unless states.size >= 2
        raise DuplicateState unless states.uniq.size == states.size
        @states = states
      end

      def add_state(state)
        self.class.new(@states + [state])
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

      def include?(state)
        @state = state
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
