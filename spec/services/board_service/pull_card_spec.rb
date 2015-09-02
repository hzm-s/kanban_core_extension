require 'rails_helper'

describe 'pull card' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }
  let(:project_service) { ProjectService.new(project_repository, board_builder) }
  let(:board_builder) { Kanban::BoardBuilder.new(board_repository) }

  let(:project_id) { project_service.launch(Project::Description.new('Name', 'Goal')) }

  before do
    project_service.specify_workflow(project_id, workflow)
  end

  context 'multi state phase, wip limit = 0' do
    let(:workflow) do
      Workflow([
        { phase: 'Todo' },
        { phase: 'Dev', transition: ['Doing', 'Done'] },
        { phase: 'QA' }
      ])
    end

    it do
      feature_id = Project::FeatureId.new('feat_1')
      service.add_card(project_id, feature_id)

      from = Position('Todo', nil)
      to = Position('Dev', 'Doing')
      service.pull_card(project_id, feature_id, from, to)

      board = board_repository.find(project_id)
      expect(board.get_card(feature_id).position).to eq(to)
    end

    context 'card is NOT locate to FROM position' do
      it do
        feature_id = Project::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        expect {
          service.pull_card(project_id, feature_id,
            Position('Dev', 'Done'),
            Position('QA', nil)
          )
        }.to raise_error(Kanban::CardNotFound)
      end
    end
  end

  context 'multi state phase, wip limit = 2' do
    let(:workflow) do
      Workflow([
        { phase: 'Todo' },
        { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 }
      ])
    end

    context 'wip = 0' do
      it do
        feature_id = Project::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        from = Position('Todo', nil)
        to = Position('Dev', 'Doing')
        service.pull_card(project_id, feature_id, from, to)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(to)
      end
    end

    context 'wip = 1' do
      before do
        other = Project::FeatureId.new('feat_other')
        service.add_card(project_id, other)
        service.pull_card(project_id, other, Position('Todo', nil), Position('Dev', 'Doing'))
      end

      it do
        feature_id = Project::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        from = Position('Todo', nil)
        to = Position('Dev', 'Doing')
        service.pull_card(project_id, feature_id, from, to)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(to)
      end
    end

    context 'wip = 2' do
      before do
        other1 = Project::FeatureId.new('feat_other1')
        other2 = Project::FeatureId.new('feat_other2')
        service.add_card(project_id, other1)
        service.add_card(project_id, other2)
        service.pull_card(project_id, other1, Position('Todo', nil), Position('Dev', 'Doing'))
        service.pull_card(project_id, other2, Position('Todo', nil), Position('Dev', 'Doing'))
      end

      it do
        feature_id = Project::FeatureId.new('feat_1')
        service.add_card(project_id, feature_id)

        from = Position('Todo', nil)
        to = Position('Dev', 'Doing')
        expect {
          service.pull_card(project_id, feature_id, from, to)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end

  context 'workflow contains 3 phases' do
    let(:workflow) do
      Workflow([
        { phase: 'Phase1' },
        { phase: 'Phase2' },
        { phase: 'Phase3' }
      ])
    end

    it do
      feature_id = Project::FeatureId.new('feat_1')
      service.add_card(project_id, feature_id)

      from = Position('Phase1', nil)
      to = Position('Phase3', nil)
      expect {
        service.pull_card(project_id, feature_id, from, to)
      }.to raise_error(Project::OutOfWorkflow)
    end
  end
end
