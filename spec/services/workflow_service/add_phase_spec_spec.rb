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

  context 'no current workflow' do
    it do
      phase_spec = PhaseSpec(phase: 'New')
      service.add_phase_spec(project_id, phase_spec)

      workflow = project_repository.find(project_id).workflow
      expect(workflow).to eq(Workflow([{ phase: 'New' }]))
    end
  end

  context 'current workflow = Head | Body | Tail' do
    before do
      service.add_phase_spec(project_id, PhaseSpec(phase: 'Head'))
      service.add_phase_spec(project_id, PhaseSpec(phase: 'Body'))
      service.add_phase_spec(project_id, PhaseSpec(phase: 'Tail'))
    end

    context 'add before Body' do
      it do
        phase_spec = PhaseSpec(phase: 'New')
        service.add_phase_spec(project_id, phase_spec, before: Phase('Body'))
        workflow = project_repository.find(project_id).workflow
        expect(workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'New' }, { phase: 'Body' }, { phase: 'Tail' }
        ]))
      end
    end

    context 'add after Body' do
      it do
        phase_spec = PhaseSpec(phase: 'New')
        service.add_phase_spec(project_id, phase_spec, after: Phase('Body'))
        workflow = project_repository.find(project_id).workflow
        expect(workflow).to eq(Workflow([
          { phase: 'Head' }, { phase: 'Body' }, { phase: 'New' }, { phase: 'Tail' }
        ]))
      end
    end
  end
end
