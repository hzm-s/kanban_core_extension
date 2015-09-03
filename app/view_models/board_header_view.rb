BoardHeaderView = Struct.new(:project_name, :phases, :phase_states) do

  Phase = Struct.new(:name, :wip_limit, :state_size)

  def self.generate(project_with_workflow)
    Generator
      .new(project_with_workflow)
      .generate
  end

  class Generator

    def initialize(project_with_workflow)
      @project_with_workflow = project_with_workflow
      @phase_specs = project_with_workflow.phase_spec_records.order(:order)
      @states = project_with_workflow.state_records.order(:order)
    end

    def generate
      BoardHeaderView.new(project_name, phases, phase_states)
    end

    def project_name
      @project_with_workflow.description_name
    end

    def phases
      @phase_specs.map do |phase_spec|
        Phase.new(
          phase_spec.phase_name,
          phase_spec.wip_limit_count,
          @states.where(phase_name: phase_spec.phase_name).size
        )
      end
    end

    def phase_states
      @phase_specs.map(&:phase_name).flat_map do |phase_name|
        if (states = @states.where(phase_name: phase_name)).any?
          states.pluck(:state_name)
        else
          ''
        end
      end
    end
  end
end
