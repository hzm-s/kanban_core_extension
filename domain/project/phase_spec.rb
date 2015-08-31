module Project
  class PhaseSpec
    attr_reader :phase, :wip_limit

    def self.modelize(phase_record, state_records)
      new(
        Phase.new(phase_record.phase_description),
        state_records.any? ? Transition.modelize(state_records) : Transition::None.new,
        phase_record.wip_limit_count ? WipLimit.new(phase_record.wip_limit_count) : WipLimit::None.new
      )
    end

    def initialize(phase, transition, wip_limit)
      @phase = phase
      @transition = transition
      @wip_limit = wip_limit
    end

    def first_situation
      Situation.new(@phase, @transition.first)
    end

    def correct_transition?(before, after)
      @transition.partial?(before.state, after.state)
    end

    # ARize

    def arize(project_record, n)
      project_record.phase_spec_records.build(
        order: n,
        phase_description: @phase.to_s,
        wip_limit_count: @wip_limit.to_i
      )
      @transition.arize(project_record, @phase.to_s)
    end
  end
end
