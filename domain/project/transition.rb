module Project
  class StateNotFound < StandardError; end
  class DuplicateState < StandardError; end
  class NeedMoreThanOneState < StandardError; end

  class Transition

    def self.from_array(state_names)
      return NoTransition.new if Array(state_names).empty?
      states = state_names
                 .reject {|n| n.empty? }
                 .map {|n| State.new(n) }
      new(states)
    end

    def initialize(states)
      set_states(states)
    end

    def insert_before(new, base)
      return add(new) if base.complete?
      renew do |current|
        current.flat_map {|s| s == base ? [new, s] : s }
      end
    end

    def remove(state)
      raise StateNotFound unless include?(state)
      renew do |current|
        current.reject {|s| s == state }
      end
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

    def operation_for_state(state)
      ops = [
        Operations::InsertStateBefore.new,
        Operations::InsertStateAfter.new
      ]
      ops << Operations::RemoveState.new if @states.size >= 3
      ops
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
        raise NeedMoreThanOneState unless states.size >= 2
        raise DuplicateState unless states.uniq.size == states.size
        @states = states
      end

      def add(state)
        renew {|current| current + [state] }
      end

      def renew
        new_states = yield(@states)
        self.class.new(new_states)
      end
  end
end
