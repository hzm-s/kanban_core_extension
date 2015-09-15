require 'rails_helper'

describe 'add phase spec' do
  let(:service) do
    WorkflowService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) do
    ProjectService().launch(Project::Description.new('Name', 'Goal'))
  end

  let(:new_workflow) do
    project_repository.find(project_id).workflow
  end

  context 'no current workflow' do
    context 'add' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'))
        expect(new_workflow).to eq(Workflow([{ phase: 'New' }]))
      end
    end

    context 'insert before Head' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), before: Phase('Head'))
        expect(new_workflow).to eq(Workflow([{ phase: 'New' }]))
      end
    end

    context 'insert after Head' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), after: Phase('Head'))
        expect(new_workflow).to eq(Workflow([{ phase: 'New' }]))
      end
    end
  end

  context 'current workflow = Head | Body | Tail' do
    before do
      service.add_phase_spec(project_id, PhaseSpec(phase: 'Head'))
      service.add_phase_spec(project_id, PhaseSpec(phase: 'Body'))
      service.add_phase_spec(project_id, PhaseSpec(phase: 'Tail'))
    end

    context 'add' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }, { phase: 'New' }
        ]))
      end
    end

    context 'insert before Head' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), before: Phase('Head'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'New' }, { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }
        ]))
      end
    end

    context 'insert after Head' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), after: Phase('Head'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
        ]))
      end
    end

    context 'insert before Body' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), before: Phase('Body'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
        ]))
      end
    end

    context 'insert after Body' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), after: Phase('Body'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
        ]))
      end
    end

    context 'insert before Tail' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), before: Phase('Tail'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
        ]))
      end
    end

    context 'insert after Tail' do
      it do
        service.add_phase_spec(project_id, PhaseSpec(phase: 'New'), after: Phase('Tail'))
        expect(new_workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'Body' }, { phase: 'Tail' }, { phase: 'New' }
        ]))
      end
    end
  end
end
