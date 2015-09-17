require 'rails_helper'

describe 'remove state' do
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

  let(:phase) { Phase('Dev') }

  context 'states = Doing|Review|Done' do
    let(:workflow) do
      Workflow([{ phase: phase, transition: ['Doing', 'Review', 'Done'] }])
    end

    pending 'no card' do
      it do
        state = State.new('Review')
        service.remove_state(project_id, phase, state)
        new_workflow = project_repository.find(project_id).workflow
        expect(new_workflow).to eq(
          Workflow([{ phase: phase, transition: ['Doing', 'Done'] }])
        )
      end
    end
  end
end
