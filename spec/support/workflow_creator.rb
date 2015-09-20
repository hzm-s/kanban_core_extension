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
end
