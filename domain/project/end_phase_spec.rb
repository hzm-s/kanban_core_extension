module Project
  class EndPhaseSpec

    def first_step
      Step::Complete.new
    end

    def last?
      true
    end

    def eql?
      self == other
    end

    def ==(other)
      other.instance_of?(self.class)
    end
  end
end
