module Feature
  class FeatureId

    def initialize(id)
      @id = id
    end

    def to_s
      @id
    end

    def hash
      to_s.hash
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_s == other.to_s
    end
  end
end
