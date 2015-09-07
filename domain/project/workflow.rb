module Project
  class Workflow

    def initialize(phase_specs)
      @phase_specs = phase_specs
    end

    def first_situation
      @phase_specs.first.first_situation
    end

    def next_situation(current_situation)
      current_phase_spec = retrieve(current_situation.phase)
      next_phase_spec = next_of(current_phase_spec)

      return Situation::Complete.new unless next_phase_spec
      current_phase_spec.next_situation(current_situation, next_phase_spec)
    end

    def reach_wip_limit?(phase, wip)
      retrieve(phase).reach_wip_limit?(wip)
    end

    def to_a
      @phase_specs
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

    private

      def retrieve(phase)
        @phase_specs.detect {|ps| ps.phase == phase }
      end

      def next_of(current)
        @phase_specs[@phase_specs.index(current) + 1]
      end
  end
end
