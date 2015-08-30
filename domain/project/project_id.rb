module Project
  class ProjectId

    def initialize(id)
      @id = id
    end

    def to_s
      @id
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
