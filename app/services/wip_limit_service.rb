class WipLimitService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def change(project_id, phase, new_wip_limit)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    workflow_factory = Activity::WorkflowBuilder.new(project.workflow)
    phase_spec_factory = Activity::PhaseSpecBuilder.new(project.workflow.spec(phase))

    phase_spec_factory.change_wip_limit(new_wip_limit, board)
    workflow_factory.replace_phase_spec(phase_spec_factory.build_phase_spec, phase)
    project.specify_workflow(workflow_factory.build_workflow)

    @project_repository.store(project)
  end
end
