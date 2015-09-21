class WipLimitService
  include PhaseSpecHelper

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
end
