module StageCreator

  def Stage(phase_name, state_name = '')
    Kanban::Stage.new(
      Phase(phase_name),
      State(state_name)
    )
  end

  def Phase(name)
    Project::Phase.new(name)
  end

  def State(name)
    Project::State.from_string(name)
  end
end