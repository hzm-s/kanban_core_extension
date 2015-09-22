class LaunchProjectCommand
  include ActiveModel::Model
  include DomainObjectConversion

  attr_accessor :name, :goal, :kickstart

  validates :name, presence: true
  validates :goal, presence: true

  def kickstart
    return false if @kickstart == "0"
    true
  end

  def description
    Project::Description.new(self.name, self.goal)
  end

  def execute(service)
    return false unless valid?

    if kickstart
      service.launch_with_workflow(description, kickstart_workflow)
    else
      service.launch(description)
    end
  end

  private

    def kickstart_workflow
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
