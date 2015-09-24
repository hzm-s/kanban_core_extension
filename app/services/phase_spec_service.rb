class PhaseSpecService
  include PhaseSpecHelper

  def initialize(project_repository, board_repository, board_maintainer)
    @project_repository = project_repository
    @board_repository = board_repository
    @board_maintainer = board_maintainer
  end

  def set_transition(project_id, phase, states)
    EventPublisher.subscribe(@board_maintainer)

    project = @project_repository.find(project_id)
    # TODO: move replace_phase_spec to WorkflowBuilder
    new_workflow = replace_phase_spec(project, phase) do |current|
                     current.set_transition(states)
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  def add_state(project_id, phase, state, option)
    project = @project_repository.find(project_id)

    position, base_state = option.flatten
    new_workflow = replace_phase_spec(project, phase) do |current|
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

    new_workflow = replace_phase_spec(project, phase) do |current|
                     current.remove_state(state, board)
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end
end
