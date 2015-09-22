require 'rails_helper'

describe 'remove phase spec' do
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

  context 'no state phase' do
    let(:workflow) { Activity::Workflow.new([target, rest]) }

    let(:target) { PhaseSpec(phase: 'Todo') }
    let(:rest) { PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3) }

    context 'no card' do
      it do
        service.remove_phase_spec(project_id, target.phase)
        new_workflow = project_repository.find(project_id).workflow
        expect(new_workflow).to eq(Activity::Workflow.new([rest]))
      end
    end

    context 'card exists' do
      it do
        feature_id = FeatureId('feat_1')
        board_service.add_card(project_id, feature_id)

        expect {
          service.remove_phase_spec(project_id, target.phase)
        }.to raise_error(Activity::CardOnPhase)
      end
    end
  end

  context 'multi state phase' do
    let(:workflow) { Activity::Workflow.new([target, rest]) }

    let(:target) { PhaseSpec(phase: 'Analyze', transition: ['Doing', 'Done']) }
    let(:rest) { PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3) }

    context 'no card' do
      it do
        service.remove_phase_spec(project_id, target.phase)
        new_workflow = project_repository.find(project_id).workflow
        expect(new_workflow).to eq(Activity::Workflow.new([rest]))
      end
    end

    context 'card exists' do
      it do
        feature_id = FeatureId('feat_1')
        board_service.add_card(project_id, feature_id)
        board_service.forward_card(project_id, feature_id, Step('Analyze', 'Doing'))

        expect {
          service.remove_phase_spec(project_id, target.phase)
        }.to raise_error(Activity::CardOnPhase)
      end
    end
  end
end
