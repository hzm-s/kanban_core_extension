module View
  class BoardHeaderBuilder

    def initialize(project_with_workflow)
      @project_with_workflow = project_with_workflow
      @phase_specs = project_with_workflow.phase_spec_records.to_a

      states = project_with_workflow.state_records.to_a
      @states_map = @phase_specs.each_with_object({}) do |phase_spec, h|
        if (phase_states = states.select {|s| s.phase_name == phase_spec.phase_name }).any?
          h[phase_spec.phase_name] = phase_states
        else
          h[phase_spec.phase_name] = []
        end
      end
    end

    def project_name
      @project_with_workflow.description_name
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

  BoardHeader = Struct.new(:project_name, :phases, :phase_states) do

    def self.build(project_with_workflow)
      builder = BoardHeaderBuilder.new(project_with_workflow)
      new(
        builder.project_name,
        builder.phases,
        builder.phase_states
      )
    end

    Phase = Struct.new(:name, :wip_limit, :state_size)
  end
end
