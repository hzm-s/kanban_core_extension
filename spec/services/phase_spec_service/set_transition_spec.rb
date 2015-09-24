require 'rails_helper'

describe 'set transition' do
  let(:service) do
    PhaseSpecService.new(project_repository, board_repository)
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

  context 'no transition' do
    let(:workflow) do
      Workflow([
        { phase: 'Dev', wip_limit: 2 },
        { phase: 'QA', transition: ['Doing', 'Done'] }
      ])
    end

    context 'no card' do
      context 'set Doing|Done' do
        it do
          service.set_transition(
            project_id,
            Phase('Dev'),
            [State('Doing'), State('Done')]
          )
          expect(new_workflow).to eq(
            Workflow([
              { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
              { phase: 'QA', transition: ['Doing', 'Done'] }
            ])
          )
        end
      end
    end

    context 'phase on card' do
      before do
        board_service.add_card(project_id, feature_id)
      end

      let(:feature_id) { FeatureId('feat_123') }

      skip 'set Doing|Done' do
        it do
          service.set_transition(
            project_id,
            Phase('Dev'),
            [State('Doing'), State('Done')]
          )

          board = board_repository.find(project_id)
          expect(board.fetch_card(feature_id, Step('Dev', 'Doing'))).to_not be_nil

          expect(new_workflow).to eq(
            Workflow([
              { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
              { phase: 'QA', transition: ['Doing', 'Done'] }
            ])
          )
        end
      end
    end
  end
end
