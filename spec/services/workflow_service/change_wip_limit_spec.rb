require 'rails_helper'

describe 'change wip limit' do
  let(:service) do
    WorkflowService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  let(:board_service) do
    BoardService(development_tracker: FakeDevelopmentTracker.new)
  end

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  let(:phase) { Phase('Todo') }
  let(:new_workflow) { project_repository.find(project_id).workflow }

  context 'no state phase' do
    let(:workflow) do
      Workflow([ phase: phase, wip_limit: old_wip_limit ])
    end

    context 'wip = 1', 'change 2 => 1' do
      let(:old_wip_limit) { Activity::WipLimit.new(2) }

      it do
        board_service.add_card(project_id, FeatureId('feat_1'))

        new_wip_limit = WipLimit(1)
        service.change_wip_limit(project_id, phase, new_wip_limit)

        expect(new_workflow).to eq(Workflow([ phase: phase, wip_limit: new_wip_limit.to_i ]))
      end
    end

    context 'wip = 2', 'change 2 => 1' do
      let(:old_wip_limit) { Activity::WipLimit.new(2) }

      it do
        board_service.add_card(project_id, FeatureId('feat_1'))
        board_service.add_card(project_id, FeatureId('feat_2'))

        expect {
          service.change_wip_limit(project_id, phase, WipLimit(1))
        }.to raise_error(Activity::UnderCurrentWip)
      end
    end
  end

  context 'mulit state phase' do
    let(:workflow) do
      Workflow([ phase: phase, transition: transition, wip_limit: old_wip_limit ])
    end
    let(:transition) { %w(Doing Done) }

    context 'wip = 2', 'change 3 => 2' do
      let(:old_wip_limit) { Activity::WipLimit.new(3) }

      it do
        board_service.add_card(project_id, FeatureId('feat_1'))
        board_service.forward_card(project_id, FeatureId('feat_1'), Step('Todo', 'Doing'))
        board_service.add_card(project_id, FeatureId('feat_2'))

        new_wip_limit = WipLimit(2)
        service.change_wip_limit(project_id, phase, new_wip_limit)

        expect(new_workflow).to eq(
          Workflow([ phase: phase, transition: transition, wip_limit: new_wip_limit.to_i ])
        )
      end
    end

    context 'wip = 2', 'change 2 => 1' do
      let(:old_wip_limit) { Activity::WipLimit.new(2) }

      it do
        board_service.add_card(project_id, FeatureId('feat_1'))
        board_service.forward_card(project_id, FeatureId('feat_1'), Step('Todo', 'Doing'))
        board_service.add_card(project_id, FeatureId('feat_2'))

        expect {
          service.change_wip_limit(project_id, phase, WipLimit(1))
        }.to raise_error(Activity::UnderCurrentWip)
      end
    end
  end
end
