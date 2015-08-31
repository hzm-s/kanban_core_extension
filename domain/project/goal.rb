module Project
  class Goal

    def initialize(goal)
      @goal
    end

    def to_s
      @goal
    end

    def eql?(other)
      self == other
    end

    def hash
      to_s.hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_s == other.to_s
    end
  end
end
