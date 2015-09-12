require 'rails_helper'

describe 'change wip limit' do
  let(:service) do
    ProjectService.new(project_repository, board_repository, board_builder)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }
  let(:board_builder) { Kanban::BoardBuilder.new(board_repository) }

  let(:project_id) do
    service.launch(Project::Description.new('Name', 'Goal'))
  end

  let(:board_service) do
    BoardService.new(project_repository, board_repository, development_tracker)
  end
  let(:board_repository) { BoardRepository.new }
  let(:development_tracker) { FakeDevelopmentTracker.new }

  it do
    phase = Phase('Todo')

    service.specify_workflow(project_id, Workflow([{ phase: phase }]))
    board_service.add_card(project_id, FeatureId('feat_1'))

    new_wip_limit = WipLimit(1)
    service.change_wip_limit(project_id, phase, new_wip_limit)

    project = project_repository.find(project_id)
    expect(project.workflow).to eq(Workflow([ phase: phase, wip_limit: new_wip_limit.to_i ]))
  end

  it do
    phase = Phase('Todo')

    service.specify_workflow(
      project_id,
      Workflow([{ phase: phase, wip_limit: 1 }])
    )
    board_service.add_card(project_id, FeatureId('feat_1'))

    new_wip_limit = WipLimit(2)
    service.change_wip_limit(project_id, phase, new_wip_limit)

    project = project_repository.find(project_id)
    expect(project.workflow).to eq(Workflow([ phase: phase, wip_limit: new_wip_limit.to_i ]))
  end

  it do
    phase = Phase('Todo')

    service.specify_workflow(
      project_id,
      Workflow([{ phase: phase, wip_limit: 2 }])
    )
    board_service.add_card(project_id, FeatureId('feat_1'))
    board_service.add_card(project_id, FeatureId('feat_2'))

    new_wip_limit = WipLimit(1)
    expect {
      service.change_wip_limit(project_id, phase, new_wip_limit)
    }.to raise_error(Project::UnderCurrentWip)
  end
end
