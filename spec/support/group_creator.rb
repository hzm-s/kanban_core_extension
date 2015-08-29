module GroupCreator

  def create_group(spec)
    Work::Group.new(
      spec[:project_id],
      Work::Phase.new(spec[:phase]),
      create_wip_limit(spec[:wip_limit]),
      create_transition(spec[:transition]),
      create_work_list(spec[:work_list])
    )
  end

  def create_wip_limit(spec)
    if spec
      Work::WipLimit.new(spec)
    else
      Work::WipLimit::None.new
    end
  end

  def create_transition(spec)
    if spec
      Work::Transition.new(spec.map {|e| Work::State.new(e) })
    else
      Work::EmptyTransition.new
    end
  end

  def create_work_list(spec)
    works = spec.map do |(feature, state)|
      Work::Work.new(
        feature,
        state ? Work::State.new(state) : Work::State::None.new
      )
    end
    Work::WorkList.new(works)
  end
end
