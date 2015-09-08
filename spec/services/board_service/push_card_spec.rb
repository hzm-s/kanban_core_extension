require 'rails_helper'

describe 'push card' do
  let(:service) do
    BoardService.new(project_repository, board_repository, development_tracker)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }
  let(:development_tracker) { FakeDevelopmentTracker.new }

  let(:project_id) { Project('Name', 'Goal') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  context '3 state phase' do
    let(:workflow) do
      Workflow([
        { phase: 'Dev', transition: ['Doing', 'Review', 'Done'], wip_limit: 2 },
        { phase: 'Other' }
      ])
    end

    context '1 => 2' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        from = Progress('Dev', 'Doing')
        to = Progress('Dev', 'Review')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.fetch_card(feature_id, to)).to_not be_nil
      end
    end

    context '2 => 3' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)
        service.forward_card(project_id, feature_id, Progress('Dev', 'Doing'))

        from = Progress('Dev', 'Review')
        to = Progress('Dev', 'Done')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.fetch_card(feature_id, to)).to_not be_nil
      end
    end

    context 'Any cards (WipLimit) on same PHASE' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, FeatureId('feat_7'))
        service.add_card(project_id, feature_id)

        from = Progress('Dev', 'Doing')
        to = Progress('Dev', 'Review')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.fetch_card(feature_id, to)).to_not be_nil
      end
    end

    context 'card is NOT in given progress' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        expect {
          service.forward_card(project_id, feature_id, Progress('Dev', 'Review'))
        }.to raise_error(CardNotFound)
      end
    end
  end
end
