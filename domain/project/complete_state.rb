module Project
  class CompleteState

    def none?
      false
    end

    def complete?
      true
    end

    def to_s
      'Complete'
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
