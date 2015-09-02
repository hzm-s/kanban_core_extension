module Project
  class Phase

    def initialize(name)
      @name = name
    end

    def to_s
      @name
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
