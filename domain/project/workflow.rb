module Project
  class Workflow

    def initialize(phase_specs)
      @phase_specs = phase_specs
    end

    def first_step
      @phase_specs.first.first_step
    end

    def next_step(current_step)
      current_phase_spec = retrieve(current_step.phase)
      next_phase_spec = next_of(current_phase_spec)

      current_phase_spec.next_step(current_step, next_phase_spec)
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
        @phase_specs[@phase_specs.index(current) + 1] || EndPhaseSpec.new
      end
  end
end
