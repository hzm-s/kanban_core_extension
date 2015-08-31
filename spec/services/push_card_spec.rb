require 'rails_helper'

describe 'push card' do
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

  context '3 state phase' do
    let(:workflow) do
      Project::Workflow.new([
        Project::PhaseSpec.new(
          Project::Phase.new('Dev'),
          Project::Transition.new([
            Project::State.new('Doing'),
            Project::State.new('Review'),
            Project::State.new('Done')
          ]),
          Project::WipLimit.new(2)
        ),
        Project::PhaseSpec.new(
          Project::Phase.new('Other'),
          Project::Transition::None.new,
          Project::WipLimit::None.new
        )
      ])
    end

    context '1 => 2' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)

        before = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Doing'))
        after = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Review'))
        service.push_card(project_id, card, before, after)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(after)
      end
    end

    context '2 => 3' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)
        service.push_card(
          project_id, card,
          Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Doing')),
          Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Review'))
        )

        before = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Review'))
        after = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Done'))
        service.push_card(project_id, card, before, after)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(after)
      end
    end

    context '1 => 3' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)

        before = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Doing'))
        after = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Done'))
        expect {
          service.push_card(project_id, card, before, after)
        }.to raise_error(Project::OutOfWorkflow)
      end
    end

    context '3 => next phase' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)
        service.push_card(
          project_id, card,
          Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Doing')),
          Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Review'))
        )
        service.push_card(
          project_id, card,
          Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Review')),
          Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Done'))
        )

        before = Kanban::Position.new(Project::Phase.new('Dev'), Project::State.new('Done'))
        after = Kanban::Position.new(Project::Phase.new('Other'), Project::State::None.new)
        expect {
          service.push_card(project_id, card, before, after)
        }.to raise_error(Project::OutOfWorkflow)
      end
    end
  end
end
