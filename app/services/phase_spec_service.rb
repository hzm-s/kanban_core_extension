class PhaseSpecService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_state(project_id, phase, state, option)
    project = @project_repository.find(project_id)

    workflow_factory = Activity::WorkflowBuilder.new(project.workflow)
    phase_spec_factory = Activity::PhaseSpecBuilder.new(project.workflow.spec(phase))

    add_with_position(option) do |position, base|
      case position
      when :before
        phase_spec_factory.insert_state_before(state, base)
      when :after
        phase_spec_factory.insert_state_after(state, base)
      end
    end

    workflow_factory.replace_phase_spec(phase_spec_factory.build_phase_spec, phase)
    project.specify_workflow(workflow_factory.build_workflow)
    @project_repository.store(project)
  end

  def remove_state(project_id, phase, state)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    workflow_factory = Activity::WorkflowBuilder.new(project.workflow)
    phase_spec_factory = Activity::PhaseSpecBuilder.new(project.workflow.spec(phase))

    phase_spec_factory.remove_state(state, board)
    workflow_factory.replace_phase_spec(phase_spec_factory.build_phase_spec, phase)
    project.specify_workflow(workflow_factory.build_workflow)

    @project_repository.store(project)
  end

  private

    def add_with_position(option)
      position, base = Hash(option).flatten
      yield(position, base)
    end
end
