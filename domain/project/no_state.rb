module Project
  class NoState

    def none?
      true
    end

    def complete?
      false
    end

    def to_s
      ''
    end

    def eql?(other)
      self == other
    end

    def hash
      to_s.hash
    end

    def ==(other)
      other.instance_of?(self.class)
    end
  end
end
