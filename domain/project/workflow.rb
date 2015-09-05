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
      next_phase_spec = @phase_specs[index(current_situation.phase) + 1]
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

      def index(phase)
        @phase_specs.index {|ps| ps.phase == phase }
      end
  end
end
