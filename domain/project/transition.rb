module Project
  class Transition
    include Enumerable

    def initialize(states)
      @states = states
    end

    def each
      return @states unless block_given?
      @states.each {|e| yield(e) }
    end

    def first
      @states.first
    end

    def next(state)
      next_index = @states.index(state) + 1
      @states[next_index]
    end
  end

  class Transition
    class None

      def first
        State::None.new
      end
    end
  end
end
