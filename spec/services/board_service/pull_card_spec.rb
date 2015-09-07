require 'rails_helper'

describe 'pull card' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  context 'multi state phase, wip limit = 0' do
    let(:workflow) do
      Workflow([
        { phase: 'Todo' },
        { phase: 'Dev', transition: ['Doing', 'Done'] },
        { phase: 'QA' }
      ])
    end

    it do
      feature_id = FeatureId('feat_1')
      service.add_card(project_id, feature_id)

      from = Stage('Todo')
      to = Stage('Dev', 'Doing')
      service.forward_card(project_id, feature_id, from)

      board = board_repository.find(project_id)
      expect(board.fetch_card(feature_id, to)).to_not be_nil
    end

    context 'card is NOT locate to FROM stage' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        expect {
          service.forward_card(project_id, feature_id, Stage('Dev', 'Done'))
        }.to raise_error(Kanban::CardNotFound)
      end
    end
  end

  context 'multi state phase, wip limit = 2' do
    let(:workflow) do
      Workflow([
        { phase: 'Todo' },
        { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
        { phase: 'QA', transition: ['Doing', 'Done'], wip_limit: 1 }
      ])
    end

    context 'wip = 0' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        from = Stage('Todo')
        to = Stage('Dev', 'Doing')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.fetch_card(feature_id, to)).to_not be_nil
      end
    end

    context 'wip = 1' do
      before do
        other = FeatureId('feat_other')
        service.add_card(project_id, other)
        service.forward_card(project_id, other, Stage('Todo'))
      end

      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        from = Stage('Todo')
        to = Stage('Dev', 'Doing')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.fetch_card(feature_id, to)).to_not be_nil
      end
    end

    context 'wip = 2 (Doing:2, Done:0)' do
      before do
        other1 = FeatureId('feat_other1')
        other2 = FeatureId('feat_other2')
        service.add_card(project_id, other1)
        service.add_card(project_id, other2)
        service.forward_card(project_id, other1, Stage('Todo'))
        service.forward_card(project_id, other2, Stage('Todo'))
      end

      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        from = Stage('Todo')
        expect {
          service.forward_card(project_id, feature_id, from)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end

    context 'wip = 2 (Doing:1, Done:1)' do
      before do
        other1 = FeatureId('feat_other1')
        other2 = FeatureId('feat_other2')
        service.add_card(project_id, other1)
        service.add_card(project_id, other2)
        service.forward_card(project_id, other1, Stage('Todo'))
        service.forward_card(project_id, other2, Stage('Todo'))
        service.forward_card(project_id, other1, Stage('Dev', 'Doing'))
      end

      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        from = Stage('Todo')
        expect {
          service.forward_card(project_id, feature_id, from)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end
end
