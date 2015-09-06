require 'rails_helper'

describe 'query for add card to board' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  context 'no wip limit' do
    let(:workflow) do
      Workflow([{ phase: 'Todo' }])
    end

    it do
      expect(service.can_add_card?(project_id)).to be_truthy
    end
  end

  context 'wip limit = 1' do
    let(:workflow) do
      Workflow([{ phase: 'Todo', wip_limit: 1 }])
    end

    context 'wip = 0' do
      it do
        expect(service.can_add_card?(project_id)).to be_truthy
      end
    end

    context 'wip = 1' do
      before do
        service.add_card(project_id, FeatureId('feat_200'))
      end

      it do
        expect(service.can_add_card?(project_id)).to be_falsy
      end
    end
  end
end
