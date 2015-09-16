module Project
  class State

    def self.from_string(string)
      return None.new if string == ''
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

  class State
    class None

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

  class State
    class Complete

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
end
