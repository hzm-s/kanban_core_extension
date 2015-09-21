require 'rails_helper'

describe 'disable wip limit' do
  let(:service) do
    WipLimitService.new(project_repository, board_repository)
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

  let(:new_workflow) { project_repository.find(project_id).workflow }

  context 'no card' do
    let(:workflow) { Workflow([{ phase: 'Dev', wip_limit: 3 }]) }

    it do
      service.disable(project_id, Phase('Dev'))
      expect(new_workflow).to eq(Workflow([{ phase: 'Dev' }]))
    end
  end

  context 'cards on phase' do
    let(:workflow) do
      Workflow([{ phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3 }])
    end

    it do
      board_service.add_card(project_id, FeatureId('feat_1'))
      board_service.add_card(project_id, FeatureId('feat_2'))
      board_service.forward_card(project_id, FeatureId('feat_2'), Step('Dev', 'Doing'))

      service.disable(project_id, Phase('Dev'))
      expect(new_workflow).to eq(Workflow([{ phase: 'Dev', transition: ['Doing', 'Done'] }]))
    end
  end
end
