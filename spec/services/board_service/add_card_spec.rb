require 'rails_helper'

include ProjectCreator

describe 'add feature to board' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  context 'no state phase no wip limit' do
    let(:workflow) do
      Workflow([{ phase: 'Todo' }])
    end

    it do
      feature_id = Backlog::FeatureId.new('feat_1')

      service.add_card(project_id, feature_id)

      board = board_repository.find(project_id)
      expect(board.get_card(feature_id).position).to eq(Position('Todo', nil))
    end
  end

  context 'no state phase, wip limit = 3' do
    let(:workflow) do
      Workflow([{ phase: 'Todo', wip_limit: 3 }])
    end

    context 'wip = 0' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')

        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(Position('Todo', nil))
      end
    end

    context 'wip = 2' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')

        service.add_card(project_id, Backlog::FeatureId.new('feat_2'))
        service.add_card(project_id, Backlog::FeatureId.new('feat_3'))
        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(Position('Todo', nil))
      end
    end

    context 'wip = 3' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')

        service.add_card(project_id, Backlog::FeatureId.new('feat_2'))
        service.add_card(project_id, Backlog::FeatureId.new('feat_3'))
        service.add_card(project_id, Backlog::FeatureId.new('feat_4'))
        expect {
          service.add_card(project_id, feature_id)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end

  context 'multi state phase no wip limit' do
    let(:workflow) do
      Workflow([{ phase: 'Todo', transition: ['Check', 'Ready'] }])
    end

    it do
      feature_id = Backlog::FeatureId.new('feat_1')

      service.add_card(project_id, feature_id)

      board = board_repository.find(project_id)
      expect(board.get_card(feature_id).position).to eq(Position('Todo', 'Check'))
    end
  end

  context 'multi state phase, wip limit = 3' do
    let(:workflow) do
      Workflow([
        { phase: 'Todo', transition: ['Check', 'Ready'], wip_limit: 3 }
      ])
    end

    context 'wip = 0' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')

        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(Position('Todo', 'Check'))
      end
    end

    context 'wip = 2' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')

        service.add_card(project_id, Backlog::FeatureId.new('feat_2'))
        service.add_card(project_id, Backlog::FeatureId.new('feat_3'))
        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(Position('Todo', 'Check'))
      end
    end

    context 'wip = 3' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')

        service.add_card(project_id, Backlog::FeatureId.new('feat_2'))
        service.add_card(project_id, Backlog::FeatureId.new('feat_3'))
        service.add_card(project_id, Backlog::FeatureId.new('feat_4'))
        expect {
          service.add_card(project_id, feature_id)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end
end
