module PositionCreator

  def Position(phase_name, state_description)
    Kanban::Position.new(
      Phase(phase_name),
      State(state_description)
    )
  end

  def Phase(name)
    Project::Phase.new(name)
  end

  def State(description)
    return Project::State::None.new unless description
    Project::State.new(description)
  end
end
