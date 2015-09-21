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
        service.add_phase_spec(
          project_id,
          {
            phase: Phase('Dev'),
            transition: Transition(['Doing', 'Done']),
            wip_limit: WipLimit(3)
          }
        )
        expect(new_workflow).to eq(
          Workflow([
            { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3 }
          ])
        )
      end
    end
  end

  context 'current workflow = Head | Body | Tail' do
    before do
      project_repository.find(project_id).tap do |project|
        project.specify_workflow(
          Workflow([
            { phase: 'Head' },
            { phase: 'Body' },
            { phase: 'Tail' }
          ])
        )
        project_repository.store(project)
      end
    end

    context 'add' do
      it do
        service.add_phase_spec(
          project_id,
          {
            phase: Phase('New'),
            transition: Transition(['Doing', 'Done']),
            wip_limit: WipLimit(3)
          }
        )
        expect(new_workflow).to eq(
          Workflow([
            { phase: 'Head' },
            { phase: 'Body' },
            { phase: 'Tail' },
            { phase: 'New', transition: ['Doing', 'Done'], wip_limit: 3 }
          ])
        )
      end
    end

    context 'insert before' do
      it do
        service.add_phase_spec(
          project_id,
          {
            phase: Phase('New'),
            transition: Transition(['Doing', 'Done']),
            wip_limit: WipLimit(3)
          },
          { before: Phase('Body') }
        )
        expect(new_workflow).to eq(
          Workflow([
            { phase: 'Head' },
            { phase: 'New', transition: ['Doing', 'Done'], wip_limit: 3 },
            { phase: 'Body' },
            { phase: 'Tail' }
          ])
        )
      end
    end

    context 'insert after' do
      it do
        service.add_phase_spec(
          project_id,
          {
            phase: Phase('New'),
            transition: Transition(['Doing', 'Done']),
            wip_limit: WipLimit(3)
          },
          { after: Phase('Body') }
        )
        expect(new_workflow).to eq(
          Workflow([
            { phase: 'Head' },
            { phase: 'Body' },
            { phase: 'New', transition: ['Doing', 'Done'], wip_limit: 3 },
            { phase: 'Tail' }
          ])
        )
      end
    end
  end
end
