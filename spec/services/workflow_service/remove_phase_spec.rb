require 'rails_helper'

describe 'remove phase spec' do
  let(:service) do
    WorkflowService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  let(:board_service) do
    BoardService(board_repository: board_repository, development_tracker: FakeDevelopmentTracker.new)
  end

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  context 'no state phase' do
    let(:workflow) { Project::Workflow.new([target, rest]) }

    let(:target) { PhaseSpec(phase: 'Todo') }
    let(:rest) { PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3) }

    context 'no card' do
      it do
        service.remove_phase_spec(project_id, target.phase)
        new_workflow = project_repository.find(project_id).workflow
        expect(new_workflow).to eq(Project::Workflow.new([rest]))
      end
    end
  end

  context 'workflow has only 1 phase spec' do
    let(:workflow) { Workflow([{ phase: 'Dev' }]) }

    it do
      expect {
        service.remove_phase_spec(project_id, Phase('Dev'))
      }.to raise_error(Project::NoMorePhaseSpec)
    end
  end
end
