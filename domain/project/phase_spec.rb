module Project
  class PhaseSpec
    attr_reader :phase, :transition, :wip_limit

    def initialize(phase, transition, wip_limit)
      @phase = phase
      @transition = transition
      @wip_limit = wip_limit
    end

    def reach_wip_limit?(wip)
      @wip_limit.reach?(wip)
    end

    def correct_transition?(before, after)
      @transition.partial?(before.state, after.state)
    end

    def transit?
      !@transition.none?
    end

    def next_situation(current_situation, next_phase_spec)
      return next_phase_spec.first_situation unless transit?
      return next_phase_spec.first_situation if @transition.last?(current_situation.state)
      Situation.new(@phase, @transition.next(current_situation.state))
    end

    def first_situation
      Situation.new(@phase, @transition.first)
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
