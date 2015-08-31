module PositionCreator

  def Position(phase_description, state_description)
    Kanban::Position.new(
      Phase(phase_description),
      State(state_description)
    )
  end

  def Phase(description)
    Project::Phase.new(description)
  end

  def State(description)
    return Project::State::None.new unless description
    Project::State.new(description)
  end
end
