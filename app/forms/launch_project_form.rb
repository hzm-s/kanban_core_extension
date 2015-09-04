class LaunchProjectForm
  include ActiveModel::Model

  attr_accessor :name, :goal, :kickstart

  validates :name, presence: true
  validates :goal, presence: true

  def kickstart
    return false if @kickstart == "false"
    true
  end

  def description
    Project::Description.new(self.name, self.goal)
  end

  def prefer(service)
    if kickstart
      service.launch_with_workflow(description, kickstart_workflow)
    else
      service.launch(description)
    end
  end

  private

    def kickstart_workflow
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('次やる'),
          Project::Transition::None.new,
          Project::WipLimit.new(2)
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('要求分析'),
          Project::Transition.new([
            Project::State.new('Doing'),
            Project::State.new('Done')
          ]),
          Project::WipLimit.new(3)
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('開発'),
          Project::Transition.new([
            Project::State.new('Doing'),
            Project::State.new('Done')
          ]),
          Project::WipLimit.new(3)
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('受け入れ'),
          Project::Transition.new([
            Project::State.new('Doing'),
            Project::State.new('Done')
          ]),
          Project::WipLimit.new(2)
        )
      ])
    end
end
