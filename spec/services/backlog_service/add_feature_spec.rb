require 'rails_helper'

describe 'add feature to backlog' do
  let(:service) do
    BacklogService.new(backlog_repository)
  end
  let(:backlog_repository) { FakeBacklogRepository.new }

  let(:project_service) do
    ProjectService.new(project_repository, board_builder)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_builder) { Kanban::BoardBuilder.new(board_repository) }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) { project_service.launch(Project::Description.new('Name', 'Goal')) }

  it do
    backlog = ::Backlog::Backlog.new
    backlog.prepare(project_id)
    backlog_repository.store(backlog)

    description = Backlog::FeatureDescription.new('Summary', 'Detail')

    feature_id = service.add_feature(project_id, description)

    backlog = backlog_repository.find(project_id)
    expect(backlog.recent_feature).to eq(feature_id)
  end
end
