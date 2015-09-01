require 'rails_helper'

describe 'add feature_id to board' do
  let(:service) do
    BoardService.new(project_repository, board_repository)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { FakeBoardRepository.new }
  let(:project_service) { ProjectService.new(project_repository, board_builder) }
  let(:board_builder) { Kanban::BoardBuilder.new(board_repository) }

  let(:project_id) { project_service.launch(Project::Description.new('Name', 'Goal')) }

  before do
    project_service.specify_workflow(project_id, workflow)
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
      feature_id = Project::FeatureId.new('feat_1')

      service.add_card(project_id, feature_id)

      board = board_repository.find(project_id)
      expect(board.get_card(feature_id).position).to eq(
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
        feature_id = Project::FeatureId.new('feat_1')

        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State::None.new)
        )
      end
    end

    context 'wip = 2' do
      it do
        feature_id = Project::FeatureId.new('feat_1')

        service.add_card(project_id, Project::FeatureId.new('feat_2'))
        service.add_card(project_id, Project::FeatureId.new('feat_3'))
        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State::None.new)
        )
      end
    end

    context 'wip = 3' do
      it do
        feature_id = Project::FeatureId.new('feat_1')

        service.add_card(project_id, Project::FeatureId.new('feat_2'))
        service.add_card(project_id, Project::FeatureId.new('feat_3'))
        service.add_card(project_id, Project::FeatureId.new('feat_4'))
        expect {
          service.add_card(project_id, feature_id)
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
      feature_id = Project::FeatureId.new('feat_1')

      service.add_card(project_id, feature_id)

      board = board_repository.find(project_id)
      expect(board.get_card(feature_id).position).to eq(
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
        feature_id = Project::FeatureId.new('feat_1')

        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State.new('Check'))
        )
      end
    end

    context 'wip = 2' do
      it do
        feature_id = Project::FeatureId.new('feat_1')

        service.add_card(project_id, Project::FeatureId.new('feat_2'))
        service.add_card(project_id, Project::FeatureId.new('feat_3'))
        service.add_card(project_id, feature_id)

        board = board_repository.find(project_id)
        expect(board.get_card(feature_id).position).to eq(
          Kanban::Position.new(Project::Phase.new('Todo'), Project::State.new('Check'))
        )
      end
    end

    context 'wip = 3' do
      it do
        feature_id = Project::FeatureId.new('feat_1')

        service.add_card(project_id, Project::FeatureId.new('feat_2'))
        service.add_card(project_id, Project::FeatureId.new('feat_3'))
        service.add_card(project_id, Project::FeatureId.new('feat_4'))
        expect {
          service.add_card(project_id, feature_id)
        }.to raise_error(Kanban::WipLimitReached)
      end
    end
  end
end
