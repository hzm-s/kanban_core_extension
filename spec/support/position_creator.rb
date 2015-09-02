module PositionCreator

  def Position(phase_name, state_name)
    Kanban::Position.new(
      Phase(phase_name),
      State(state_name)
    )
  end

  def Phase(name)
    Project::Phase.new(name)
  end

  def State(name)
    return Project::State::None.new unless name
    Project::State.new(name)
  end
end
