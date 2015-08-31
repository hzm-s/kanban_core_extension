module Project
  class State

    def initialize(state)
      @state = state
    end

    def to_s
      @state
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

    # ARize

    def arize(project_record, phase_description, n)
      project_record.state_records.build(
        phase_description: phase_description,
        order: n,
        state_description: to_s
      )
    end
  end

  class State
    class None

      def eql?(other)
        self == other
      end

      def ==(other)
        other.instance_of?(self.class)
      end
    end
  end
end
