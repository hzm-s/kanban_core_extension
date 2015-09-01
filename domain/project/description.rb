module Project
  class Description
    attr_reader :name, :goal

    def initialize(name, goal)
      @name = name
      @goal = goal
    end

    def to_a
      [@name, @goal]
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
