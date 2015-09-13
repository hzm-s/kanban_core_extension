module View
  class BoardHeaderBuilder

    def initialize(project_id_str, phase_specs, states)
      @project_id_str = project_id_str
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
        Phase.build(
          @project_id_str,
          phase_spec,
          @states_map[phase_spec.phase_name].size
        )
      end
    end

    def phase_states
      @states_map.each_with_object([]) do |(phase_name, states), a|
        if states.any?
          states.each {|s| a << State.new(s.phase_name, s.state_name) }
        else
          a << State.new(phase_name, '')
        end
      end
    end
  end
end
