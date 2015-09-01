require 'rails_helper'

describe 'specify workflow' do
  let(:service) do
    ProjectService.new(project_repository, board_service)
  end
  let(:project_repository) { ProjectRepository.new }

  let(:board_service) { BoardService.new(project_repository, board_repository) }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) do
    service.launch(Project::Description.new('Name', 'Goal'))
  end

  it do
    workflow = Project::Workflow.new([
      Project::PhaseSpec.new(
        Project::Phase.new('Todo'),
        Project::Transition::None.new,
        Project::WipLimit.new(10)
      ),
      Project::PhaseSpec.new(
        Project::Phase.new('Dev'),
        Project::Transition.new([
          Project::State.new('Doing'),
          Project::State.new('Done')
        ]),
        Project::WipLimit.new(2)
      ),
      Project::PhaseSpec.new(
        Project::Phase.new('QA'),
        Project::Transition::None.new,
        Project::WipLimit.new(1)
      )
    ])

    service.specify_workflow(project_id, workflow)

    project = project_repository.find(project_id)
    expect(project.workflow).to eq(workflow)

    board = board_repository.find(project_id)
    expect(board).to_not be_nil
  end
end
