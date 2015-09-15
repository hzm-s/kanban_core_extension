class WorkflowService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_phase_spec(project_id, phase_spec, option = nil)
    project = @project_repository.find(project_id)

    builder = Project::WorkflowBuilder.new(project.workflow)
    direction, base_phase = Hash(option).flatten

    case direction
    when :before
      builder.insert_phase_spec_before(phase_spec, base_phase)
    when :after
      builder.insert_phase_spec_after(phase_spec, base_phase)
    else
      builder.add_phase_spec(phase_spec)
    end

    project.specify_workflow(builder.workflow)
    @project_repository.store(project)
  end

  def add_state_to_phase(project_id, phase, state, option = nil)
    project = @project_repository.find(project_id)

    builder = Project::WorkflowBuilder.new(project.workflow)
    direction, base_state = Hash(option).flatten

    case direction
    when :before
      builder.insert_state_before(phase, state, base_state)
    when :after
      builder.insert_state_after(phase, state, base_state)
    else
      builder.add_state(phase, state)
    end

    project.specify_workflow(builder.workflow)
    @project_repository.store(project)
  end
end
