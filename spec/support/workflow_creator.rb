module WorkflowCreator

  def Workflow(phase_specs)
    Project::Workflow.new(phase_specs.map {|ps| PhaseSpec(ps) })
  end

  def PhaseSpec(params)
    Project::PhaseSpec.new(
      Phase(params[:phase]),
      Transition(params[:transition]),
      WipLimit(params[:wip_limit])
    )
  end

  def Phase(name_or_phase)
    return name_or_phase if name_or_phase.instance_of?(Project::Phase)
    Project::Phase.new(name_or_phase)
  end

  def Transition(params)
    return Project::NoTransition.new unless params
    Project::Transition.new(params.map {|p| Project::State.new(p) })
  end

  def WipLimit(param = nil)
    return Project::NoWipLimit.new if param.nil?
    return Project::WipLimit.new(param) if param.instance_of?(Fixnum)
    param
  end

  def KickStartWorkflow
    Project::Workflow.new([
      Project::PhaseSpec.new(
        Project::Phase.new('次やる'),
        Project::NoTransition.new,
        Project::WipLimit.new(2)
      ),
      Project::PhaseSpec.new(
        Project::Phase.new('要求分析'),
        Project::Transition.new([
          Project::State.new('Doing'),
          Project::State.new('Done')
        ]),
        Project::WipLimit.new(3)
      ),
      Project::PhaseSpec.new(
        Project::Phase.new('開発'),
        Project::Transition.new([
          Project::State.new('Doing'),
          Project::State.new('Done')
        ]),
        Project::WipLimit.new(3)
      ),
      Project::PhaseSpec.new(
        Project::Phase.new('受け入れ'),
        Project::Transition.new([
          Project::State.new('Doing'),
          Project::State.new('Done')
        ]),
        Project::WipLimit.new(2)
      )
    ])
  end
end
