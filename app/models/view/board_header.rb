module View
  class BoardHeaderBuilder

    def initialize(phase_specs, states)
      @phase_specs = phase_specs
      @states_map = @phase_specs.each_with_object({}) do |phase_spec, h|
        if (phase_states = states.select {|s| s.phase_name == phase_spec.phase_name }).any?
          h[phase_spec.phase_name] = phase_states
        else
          h[phase_spec.phase_name] = []
        end
      end
    end

    def phases
      @phase_specs.map do |phase_spec|
        Phase.new(
          phase_spec.phase_name,
          phase_spec.wip_limit_count,
          @states_map[phase_spec.phase_name].size
        )
      end
    end

    def phase_states
      @states_map.values.inject([]) do |a, states|
        a += if states.any?
               states.flat_map(&:state_name)
             else
               ['']
             end
      end
    end
  end

  BoardHeader = Struct.new(:phases, :phase_states) do

    def self.build(phase_specs, states)
      builder = BoardHeaderBuilder.new(phase_specs, states)
      new(
        builder.phases,
        builder.phase_states
      )
    end

    Phase = Struct.new(:name, :wip_limit, :state_size)
  end
end
