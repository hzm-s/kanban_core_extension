require 'rails_helper'

describe 'push card' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { FakeProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }

  let(:project_id) { project_service.launch(Project::Description.new('Name', 'Goal')) }
  let(:project_service) { ProjectService.new(project_repository, service) }

  before do
    project_service.specify_workflow(project_id, workflow)
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

        before = Position('Dev', 'Doing')
        after = Position('Dev', 'Review')
        service.push_card(project_id, card, before, after)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(after)
      end
    end

    context '2 => 3' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)
        service.push_card(project_id, card, Position('Dev', 'Doing'), Position('Dev', 'Review'))

        before = Position('Dev', 'Review')
        after = Position('Dev', 'Done')
        service.push_card(project_id, card, before, after)

        board = board_repository.find(project_id)
        expect(board.position(card)).to eq(after)
      end
    end

    context '1 => 3' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)

        before = Position('Dev', 'Doing')
        after = Position('Dev', 'Done')
        expect {
          service.push_card(project_id, card, before, after)
        }.to raise_error(Project::OutOfWorkflow)
      end
    end

    context '3 => next phase' do
      it do
        card = Kanban::Card.new(Project::FeatureId.new('feat_1'))
        service.add_card(project_id, card)
        service.push_card(project_id, card, Position('Dev', 'Doing'), Position('Dev', 'Review'))
        service.push_card(project_id, card, Position('Dev', 'Review'), Position('Dev', 'Done'))

        before = Position('Dev', 'Done')
        after = Position('Other', nil)
        expect {
          service.push_card(project_id, card, before, after)
        }.to raise_error(Project::OutOfWorkflow)
      end
    end
  end
end
