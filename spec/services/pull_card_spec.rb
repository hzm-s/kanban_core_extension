require 'rails_helper'

describe 'pull card' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { FakeProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) { Project::ProjectId.new('prj_1') }

  before do
    project = Project::Project.new(project_id)
    project.specify_workflow(workflow)
    project_repository.store(project)

    board = project.build_board
    board_repository.store(board)
  end

  context 'multi state phase, wip limit = 0' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Todo'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('Dev'),
          Project::Transition.new([
            Project::State.new('Doing'),
            Project::State.new('Done')
          ]),
          Project::WipLimit::None.new
        )
      ])
    end

    it do
      card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
      service.add_card(project_id, card)

      before = Kanban::Position.new(Project::Phase.new('Todo'), Project::State::None.new)
      after = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Doing'))
      service.pull_card(project_id, card, before, after)

      board = board_repository.find(project_id)
      expect(board.position(card)).to eq(after)
    end
  end

  context 'multi state phase, wip limit = 2' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Todo'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('Dev'),
          Project::Transition.new([
            Project::State.new('Doing'),
            Project::State.new('Done')
          ]),
          Project::WipLimit.new(2)
        )
      ])
    end

    context 'wip = 0' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)

        before = Position('Todo', nil)
        after = Position('Dev', 'Doing')
        service.pull_card(project_id, card, before, after)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(after)
      end
    end

    context 'wip = 1' do
      before do
        other = Kanban::Card.new(Project::FeatureId.new('feat_other'))
        service.add_card(project_id, other)
        service.pull_card(project_id, other, Position('Todo', nil), Position('Dev', 'Doing'))
      end

      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)

        before = Position('Todo', nil)
        after = Position('Dev', 'Doing')
        service.pull_card(project_id, card, before, after)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(after)
      end
    end

    context 'wip = 2' do
      before do
        other1 = Kanban::Card.new(Project::FeatureId.new('feat_other1'))
        other2 = Kanban::Card.new(Project::FeatureId.new('feat_other2'))
        service.add_card(project_id, other1)
        service.add_card(project_id, other2)
        service.pull_card(project_id, other1, Position('Todo', nil), Position('Dev', 'Doing'))
        service.pull_card(project_id, other2, Position('Todo', nil), Position('Dev', 'Doing'))
      end

      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)

        before = Position('Todo', nil)
        after = Position('Dev', 'Doing')
        expect {
          service.pull_card(project_id, card, before, after)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end

  context 'workflow contains 3 phases' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Phase1'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('Phase2'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('Phase3'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        )
      ])
    end

    it do
      card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
      service.add_card(project_id, card)

      before = Position('Phase1', nil)
      after = Position('Phase3', nil)
      expect {
        service.pull_card(project_id, card, before, after)
      }.to raise_error(Project::OutOfWorkflow)
    end
  end
end
