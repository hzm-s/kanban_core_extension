module Activity
  class WipLimitReached < StandardError; end

  class PhaseSpec
    attr_reader :phase, :transition, :wip_limit

    def initialize(phase, transition, wip_limit)
      @phase = phase
      @transition = transition
      @wip_limit = wip_limit
    end

    def reach_wip_limit?(wip)
      return false if wip == 0
      @wip_limit.reach?(wip)
    end

    def first_step
      Step.new(@phase, @transition.first)
    end

    def next_step(current_step, next_phase_spec)
      raise StateNotFound unless @transition.include?(current_step.state)
      return next_phase_spec.first_step if @transition.last?(current_step.state)
      Step.new(@phase, @transition.next(current_step.state))
    end

    def last?
      false
    end

    def to_h
      {
        phase: @phase,
        transition: @transition,
        wip_limit: @wip_limit
      }
    end

    def eql?(other)
      self == other
    end

    def hash
      to_h.hash
    end

    def ==(other)
      other.instance_of?(self.class) &&
        self.to_h == other.to_h
    end
  end
end
