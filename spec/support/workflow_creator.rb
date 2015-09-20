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

  def Transition(params)
    return Activity::NoTransition.new unless params
    Activity::Transition.new(params.map {|p| Activity::State.new(p) })
  end

  def WipLimit(param = nil)
    return Activity::NoWipLimit.new if param.nil?
    return Activity::WipLimit.new(param) if param.instance_of?(Fixnum)
    param
  end
end
