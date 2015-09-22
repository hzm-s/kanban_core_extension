module WorkflowCreator

  def Workflow(phase_specs)
    Activity::Workflow.new(phase_specs.map {|ps| PhaseSpec(ps) })
  end

  def PhaseSpec(params)
    Activity::PhaseSpec.new(
      Phase(params[:phase]),
      Transition(params[:transition]),
      WipLimit(params[:wip_limit])
    )
  end

  def Phase(name_or_phase)
    return name_or_phase if name_or_phase.instance_of?(Activity::Phase)
    Activity::Phase.new(name_or_phase)
  end

  def Transition(params = nil)
    return Activity::NoTransition.new unless params
    Activity::Transition.new(params.map {|p| Activity::State.new(p) })
  end

  def WipLimit(param = nil)
    return Activity::NoWipLimit.new if param.nil?
    return Activity::WipLimit.new(param) if param.instance_of?(Fixnum)
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
