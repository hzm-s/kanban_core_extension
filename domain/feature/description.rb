module Feature
  class Description
    attr_reader :summary, :detail

    def initialize(summary, detail)
      @summary = summary
      @detail = detail
    end

    def to_a
      [@summary, @detail]
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
