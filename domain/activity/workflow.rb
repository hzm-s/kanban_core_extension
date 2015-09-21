module Activity
  class DuplicatePhase < StandardError; end

  class Workflow

    def initialize(phase_specs)
      set_phase_specs(phase_specs)
    end

    def disable_wip_limit(phase)
      old = spec(phase)
      replace_with(old, old.disable_wip_limit)
    end

    def replace_with(old, new)
      renew do |current|
        current.map {|ps| ps == old ? new : ps }
      end
    end

    def first
      @phase_specs.first
    end

    def next_of(current)
      @phase_specs[@phase_specs.index(current) + 1] || EndPhaseSpec.new
    end

    def next_step(current_step)
      current_phase_spec = spec(current_step.phase)
      next_phase_spec = next_of(current_phase_spec)

      current_phase_spec.next_step(current_step, next_phase_spec)
    end

    def spec(phase)
      @phase_specs.detect {|ps| ps.phase == phase } || raise(PhaseNotFound)
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

      def set_phase_specs(phase_specs)
        raise DuplicatePhase if duplicate?(phase_specs.map(&:phase))
        @phase_specs = phase_specs
      end

      def duplicate?(phases)
        phases.uniq.size != phases.size
      end

      def renew
        new_phase_specs = yield(@phase_specs)
        self.class.new(new_phase_specs)
      end
  end
end
