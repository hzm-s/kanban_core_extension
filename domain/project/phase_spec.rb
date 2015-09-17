module Project
  class WipLimitReached < StandardError; end
  class UnderCurrentWip < StandardError; end
  class TransitionAlreadySetted < StandardError; end
  class CardOnState < StandardError; end

  class PhaseSpec
    attr_reader :phase, :transition, :wip_limit

    def initialize(phase, transition, wip_limit)
      @phase = phase
      @transition = transition
      @wip_limit = wip_limit
    end

    def operation_for_state(state)
      @transition.operation_for_state(state)
    end

    def change_wip_limit(new_wip_limit, board)
      raise UnderCurrentWip if new_wip_limit.under?(board.count_card(@phase))
      self.class.new(@phase, @transition, new_wip_limit)
    end

    def reach_wip_limit?(wip)
      return false if wip == 0
      @wip_limit.reach?(wip)
    end

    def set_transition(transition)
      raise TransitionAlreadySetted if transit?
      self.class.new(@phase, transition, @wip_limit)
    end

    def insert_state_before(new, base_state)
      raise StateNotFound unless @transition.include?(base_state)
      self.class.new(@phase, @transition.insert_before(new, base_state), @wip_limit)
    end

    def remove_state(state, board)
      raise CardOnState unless board.can_remove_step?(Step.new(@phase, state))
      self.class.new(@phase, @transition.remove(state), @wip_limit)
    end

    def first_step
      Step.new(@phase, @transition.first)
    end

    def next_step(current_step, next_phase_spec)
      raise StateNotFound unless @transition.include?(current_step.state)
      return next_phase_spec.first_step if @transition.last?(current_step.state)
      Step.new(@phase, @transition.next(current_step.state))
    end

    def transit?
      !@transition.none?
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
