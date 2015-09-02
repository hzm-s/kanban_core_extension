module WorkflowCreator

  def Workflow(phase_specs)
    Project::Workflow.new(phase_specs.map {|ps| PhaseSpec(ps) })
  end

  def PhaseSpec(params)
    Project::PhaseSpec.new(
      Project::Phase.new(params[:phase]),
      Transition(params[:transition]),
      WipLimit(params[:wip_limit])
    )
  end

  def Transition(params)
    return Project::Transition::None.new unless params
    Project::Transition.new(params.map {|p| Project::State.new(p) })
  end

  def WipLimit(param)
    return Project::WipLimit::None.new unless param
    Project::WipLimit.new(param)
  end
end
