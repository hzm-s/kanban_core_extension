require 'rails_helper'

describe 'push card' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }

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

    context 'card is NOT locate to FROM position' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        expect {
          service.forward_card(project_id, feature_id, Position('Dev', 'Review'))
        }.to raise_error(Kanban::CardNotFound)
      end
    end

    context '1 => 2' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)

        from = Position('Dev', 'Doing')
        to = Position('Dev', 'Review')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(to)
      end
    end

    context '2 => 3' do
      it do
        feature_id = FeatureId('feat_1')
        service.add_card(project_id, feature_id)
        service.forward_card(project_id, feature_id, Position('Dev', 'Doing'))

        from = Position('Dev', 'Review')
        to = Position('Dev', 'Done')
        service.forward_card(project_id, feature_id, from)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(to)
      end
    end
  end
end
