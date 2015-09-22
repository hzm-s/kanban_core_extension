module Activity
  class State

    def self.from_string(string)
      return NoState.new if string == ''
      new(string)
    end

    def initialize(name)
      @name = name
    end

    def none?
      false
    end

    def complete?
      false
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
