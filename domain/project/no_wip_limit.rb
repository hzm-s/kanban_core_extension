module Project
  class NoWipLimit

    def reach?(wip)
      false
    end

    def to_i
      nil
    end

    def eql?(other)
      self == other
    end

    def hash
      to_i.hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_i == other.to_i
    end
  end
end
