require 'rails_helper'

describe 'specify workflow' do
  let(:service) do
    ProjectService.new(project_repository, backlog_builder, board_builder)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:backlog_builder) { double(:backlog_builder) }

  let(:board_builder) { Kanban::BoardBuilder.new(board_repository) }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) do
    service.launch(Project::Description.new('Name', 'Goal'))
  end

  it do
    workflow = Workflow([
      { phase: 'Todo', wip_limit: 10 },
      { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
      { phase: 'QA', wip_limit: 1 }
    ])
    service.specify_workflow(project_id, workflow)

    project = project_repository.find(project_id)
    expect(project.workflow).to eq(workflow)

    board = board_repository.find(project_id)
    expect(board).to_not be_nil
  end
end
