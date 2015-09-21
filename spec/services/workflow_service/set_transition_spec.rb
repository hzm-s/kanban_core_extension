require 'rails_helper'

describe 'set transition' do
  let(:service) do
    WorkflowService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

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
end
