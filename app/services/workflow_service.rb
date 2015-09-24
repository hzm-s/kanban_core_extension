class WorkflowService

  def initialize(project_repository, board_repository)
    @project_repository = project_repository
    @board_repository = board_repository
  end

  def add_phase_spec(project_id, attributes, option = nil)
    project = @project_repository.find(project_id)

    phase_spec = Activity::PhaseSpec.new(
      *attributes.values_at(:phase, :transition, :wip_limit)
    )
    position, base_phase = Hash(option).flatten

    new_workflow = replace(project) do |current|
                     case position
                     when :before
                       current.insert_phase_spec_before(phase_spec, base_phase)
                     when :after
                       current.insert_phase_spec_after(phase_spec, base_phase)
                     else
                       current.add_phase_spec(phase_spec)
                     end
                  end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  def remove_phase_spec(project_id, phase)
    project = @project_repository.find(project_id)
    board = @board_repository.find(project_id)

    new_workflow = replace(project) do |current|
                     current.remove_phase_spec(phase, board)
                   end

    project.specify_workflow(new_workflow)
    @project_repository.store(project)
  end

  private

    def replace(project)
      builder = Activity::WorkflowBuilder.new(project.workflow)
      yield(builder)
    end

    def add_with_position(option)
      position, base = Hash(option).flatten
      yield(position, base)
    end
end
