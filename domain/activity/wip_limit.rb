module Activity
  class WipLimit

    def self.from_number(number)
      return new(number.to_i) if number.to_i > 0
      NoWipLimit.new
    end

    def initialize(count)
      @count = count
    end

    def reach?(wip)
      @count <= wip
    end

    def under?(wip)
      @count < wip
    end

    def to_i
      @count
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
