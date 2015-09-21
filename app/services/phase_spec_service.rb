class PhaseSpecService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def set_transition(project_id, phase, states)
    project = @project_repository.find(project_id)

    new_workflow = replace_phase_spec(project.workflow, phase) do |current|
                     current.set_transition(states)
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  def add_state(project_id, phase, state, option)
    project = @project_repository.find(project_id)

    position, base_state = option.flatten
    new_workflow = replace_phase_spec(project.workflow, phase) do |current|
                     case position
                     when :before
                       current.insert_state_before(state, base_state)
                     when :after
                       current.insert_state_after(state, base_state)
                     end
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  def remove_state(project_id, phase, state)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    new_workflow = replace_phase_spec(project.workflow, phase) do |current|
                     current.remove_state(state, board)
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  private

    def replace_phase_spec(workflow, phase)
      workflow_builder = Activity::WorkflowBuilder.new(workflow)
      phase_spec_builder = Activity::PhaseSpecBuilder.new(workflow.spec(phase))

      yield(phase_spec_builder)

      workflow_builder.replace_phase_spec(phase_spec_builder.build_phase_spec, phase)
      workflow_builder.build_workflow
    end

    def add_with_position(option)
      position, base = Hash(option).flatten
      yield(position, base)
    end
end
