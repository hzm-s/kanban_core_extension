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
    Activity::Workflow.new([
      Activity::PhaseSpec.new(
        Activity::Phase.new('次やる'),
        Activity::NoTransition.new,
        Activity::WipLimit.new(2)
      ),
      Activity::PhaseSpec.new(
        Activity::Phase.new('要求分析'),
        Activity::Transition.new([
          Activity::State.new('Doing'),
          Activity::State.new('Done')
        ]),
        Activity::WipLimit.new(3)
      ),
      Activity::PhaseSpec.new(
        Activity::Phase.new('開発'),
        Activity::Transition.new([
          Activity::State.new('Doing'),
          Activity::State.new('Done')
        ]),
        Activity::WipLimit.new(3)
      ),
      Activity::PhaseSpec.new(
        Activity::Phase.new('受け入れ'),
        Activity::Transition.new([
          Activity::State.new('Doing'),
          Activity::State.new('Done')
        ]),
        Activity::WipLimit.new(2)
      )
    ])
  end
end
