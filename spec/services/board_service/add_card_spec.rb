require 'rails_helper'

describe 'add card to board' do
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

  context 'no state phase no wip limit' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Todo'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        )
      ])
    end

    it do
      card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

      service.add_card(project_id, card)

      board = board_repository.find(project_id)
      expect(board.position(card)).to eq(
        Kanban::Position.new(Project::Phase.new('Todo'), Project::State::None.new)
      )
    end
  end

  context 'no state phase, wip limit = 3' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Todo'),
          Project::Transition::None.new,
          Project::WipLimit.new(3)
        )
      ])
    end

    context 'wip = 0' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

        service.add_card(project_id, card)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State::None.new)
        )
      end
    end

    context 'wip = 2' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_2')))
        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_3')))
        service.add_card(project_id, card)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State::None.new)
        )
      end
    end

    context 'wip = 3' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_2')))
        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_3')))
        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_4')))
        expect {
          service.add_card(project_id, card)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end

  context 'multi state phase no wip limit' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Todo'),
          Project::Transition.new([
            Project::State.new('Check'),
            Project::State.new('Ready')
          ]),
          Project::WipLimit::None.new
        )
      ])
    end

    it do
      card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

      service.add_card(project_id, card)

      board = board_repository.find(project_id)
      expect(board.position(card)).to eq(
        Kanban::Position.new(Project::Phase.new('Todo'), Project::State.new('Check'))
      )
    end
  end

  context 'multi state phase, wip limit = 3' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Todo'),
          Project::Transition.new([
            Project::State.new('Check'),
            Project::State.new('Ready')
          ]),
          Project::WipLimit.new(3)
        )
      ])
    end

    context 'wip = 0' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

        service.add_card(project_id, card)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State.new('Check'))
        )
      end
    end

    context 'wip = 2' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_2')))
        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_3')))
        service.add_card(project_id, card)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State.new('Check'))
        )
      end
    end

    context 'wip = 3' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))

        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_2')))
        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_3')))
        service.add_card(project_id, Kanban::Card.new(Project::FeatureId.new('feat_4')))
        expect {
          service.add_card(project_id, card)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end
end
