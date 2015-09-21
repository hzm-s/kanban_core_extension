require 'rails_helper'

describe 'add state' do
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

  context 'current Doing|Review|Done' do
    let(:workflow) do
      Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'Done'] }])
    end

    context 'insert before Doing' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), before: State('Doing'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['KPT', 'Doing', 'Review', 'Done'] }])
        )
      end
    end

    context 'insert after Review' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), after: State('Review'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'KPT', 'Done'] }])
        )
      end
    end
  end
end
