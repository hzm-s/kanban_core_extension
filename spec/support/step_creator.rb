module StepCreator

  def Step(phase_name, state_name = '')
    Activity::Step.new(
      Phase(phase_name),
      State(state_name)
    )
  end

  def Phase(name)
    Activity::Phase.new(name)
  end

  def State(name)
    Activity::State.from_string(name)
  end
end
