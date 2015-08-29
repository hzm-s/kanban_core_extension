module Work
  class WorkList

    def initialize(works)
      @works = works
    end

    def add(work)
      self.class.new(@works + [work])
    end

    def remove(work)
      self.class.new(@works.reject {|w| w == work })
    end

    def empty?
      @works.empty?
    end

    def to_a
      @works
    end

    def hash
      to_a.hash
    end

    def eql?
      self == other
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_a == other.to_a
    end
  end
end
