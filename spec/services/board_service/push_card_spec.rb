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
        feature_id = Backlog::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        expect {
          service.push_card(project_id, feature_id,
            Position('Dev', 'Review'),
            Position('Dev', 'Done')
          )
        }.to raise_error(Kanban::CardNotFound)
      end
    end

    context '1 => 2' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        from = Position('Dev', 'Doing')
        to = Position('Dev', 'Review')
        service.push_card(project_id, feature_id, from, to)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(to)
      end
    end

    context '2 => 3' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)
        service.push_card(project_id, feature_id, Position('Dev', 'Doing'), Position('Dev', 'Review'))

        from = Position('Dev', 'Review')
        to = Position('Dev', 'Done')
        service.push_card(project_id, feature_id, from, to)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(to)
      end
    end

    context '1 => 3' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        from = Position('Dev', 'Doing')
        to = Position('Dev', 'Done')
        expect {
          service.push_card(project_id, feature_id, from, to)
        }.to raise_error(Project::OutOfWorkflow)
      end
    end

    context '3 => next phase' do
      it do
        feature_id = Backlog::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)
        service.push_card(project_id, feature_id, Position('Dev', 'Doing'), Position('Dev', 'Review'))
        service.push_card(project_id, feature_id, Position('Dev', 'Review'), Position('Dev', 'Done'))

        from = Position('Dev', 'Done')
        to = Position('Other', nil)
        expect {
          service.push_card(project_id, feature_id, from, to)
        }.to raise_error(Project::OutOfWorkflow)
      end
    end
  end
end
