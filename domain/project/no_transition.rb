module Project
  class NoTransition

    def initialize
      @state = NoState.new
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
