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

  context 'NOT exist phase' do
    let(:workflow) do
      Workflow([{ phase: 'Todo' }])
    end

    context 'add' do
      it do
        expect {
          service.add_state(project_id, Phase('NONE'), State('Doing'))
        }.to raise_error(Project::PhaseNotFound)
      end
    end

    context 'insert before' do
      it do
        expect {
          service.add_state(project_id, Phase('NONE'), State('Doing'), before: State('NONE'))
        }.to raise_error(Project::PhaseNotFound)
      end
    end

    context 'insert after' do
      it do
        expect {
          service.add_state(project_id, Phase('NONE'), State('Doing'), after: State('NONE'))
        }.to raise_error(Project::PhaseNotFound)
      end
    end
  end

  context 'no current transition' do
    let(:workflow) do
      Workflow([{ phase: 'Todo' }])
    end

    context 'add' do
      it do
        service.add_state(project_id, Phase('Todo'), State('Doing'))
        expect(new_workflow).to eq(Workflow([{ phase: 'Todo', transition: ['Doing'] }]))
      end
    end

    context 'insert before Work' do
      it do
        service.add_state(project_id, Phase('Todo'), State('Doing'), before: State('Work'))
        expect(new_workflow).to eq(Workflow([{ phase: 'Todo', transition: ['Doing'] }]))
      end
    end

    context 'insert after Work' do
      it do
        service.add_state(project_id, Phase('Todo'), State('Doing'), after: State('Work'))
        expect(new_workflow).to eq(Workflow([{ phase: 'Todo', transition: ['Doing'] }]))
      end
    end
  end

  context 'current Doing|Review|Done' do
    let(:workflow) do
      Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'Done'] }])
    end

    context 'add' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'Done', 'KPT'] }])
        )
      end
    end

    context 'insert before Doing' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), before: State('Doing'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['KPT', 'Doing', 'Review', 'Done'] }])
        )
      end
    end

    context 'insert after Doing' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), after: State('Doing'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['Doing', 'KPT', 'Review', 'Done'] }])
        )
      end
    end

    context 'insert before Review' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), before: State('Review'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['Doing', 'KPT', 'Review', 'Done'] }])
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

    context 'insert before Done' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), before: State('Done'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'KPT', 'Done'] }])
        )
      end
    end

    context 'insert after Done' do
      it do
        service.add_state(project_id, Phase('Dev'), State('KPT'), after: State('Done'))
        expect(new_workflow).to eq(
          Workflow([{ phase: 'Dev', transition: ['Doing', 'Review', 'Done', 'KPT'] }])
        )
      end
    end
  end
end
