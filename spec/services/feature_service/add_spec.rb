require 'rails_helper'

describe 'add feature' do
  let(:service) do
    FeatureService.new(feature_repository)
  end
  let(:feature_repository) { FakeFeatureRepository.new }

  let(:project_service) do
    ProjectService.new(project_repository, board_builder)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_builder) { Kanban::BoardBuilder.new(board_repository) }
  let(:board_repository) { BoardRepository.new }

  let(:project_id) { project_service.launch(Project::Description.new('Name', 'Goal')) }

  it do
    description = Feature::Description.new('Summary', 'Detail')

    feature_id = service.add(project_id, description)

    feature = feature_repository.find(project_id, feature_id)
    expect(feature.description).to eq(description)
  end
end
