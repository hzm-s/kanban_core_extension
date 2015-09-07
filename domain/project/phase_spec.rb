module Project
  class PhaseSpec
    attr_reader :phase, :transition, :wip_limit

    def initialize(phase, transition, wip_limit)
      @phase = phase
      @transition = transition
      @wip_limit = wip_limit
    end

    def next_progress(current_progress, next_phase_spec)
      return next_phase_spec.first_progress if @transition.last?(current_progress.state)
      Progress.new(@phase, @transition.next(current_progress.state))
    end

    def first_progress
      Progress.new(@phase, @transition.first)
    end

    def reach_wip_limit?(wip)
      @wip_limit.reach?(wip)
    end

    def transit?
      !@transition.none?
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
