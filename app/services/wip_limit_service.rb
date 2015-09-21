class WipLimitService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def change(project_id, phase, new_wip_limit)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    new_workflow = replace_phase_spec(project.workflow, phase) do |current|
                     current.change_wip_limit(new_wip_limit, board)
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  def disable(project_id, phase)
    project = @project_repository.find(project_id)

    new_workflow = replace_phase_spec(project.workflow, phase) do |current|
                     current.disable_wip_limit
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
end
