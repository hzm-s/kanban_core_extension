class WorkflowService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_phase_spec(project_id, phase_spec, option = {})
    project = @project_repository.find(project_id)

    direction, base_phase = option.flatten
    builder = Project::WorkflowBuilder.new(project.workflow)
    builder.add_phase_spec(phase_spec, direction, base_phase)

    project.specify_workflow(builder.workflow)
    @project_repository.store(project)
  end
end
