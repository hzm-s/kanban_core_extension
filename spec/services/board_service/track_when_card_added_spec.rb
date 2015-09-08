require 'rails_helper'

describe 'track when card added' do
  let!(:service) do
    BoardService.new(project_repository, board_repository, development_tracker)
  end
  let(:project_repository) { ProjectRepository.new }
  let(:board_repository) { BoardRepository.new }

  let(:development_tracker) { Feature::DevelopmentTracker.new(feature_repository) }
  let(:feature_repository) { FeatureRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  before do
    ProjectService().specify_workflow(project_id, workflow)
  end

  let(:workflow) { Workflow([{ phase: 'Todo' }]) }

  it do
    feature_id = Feature(project_id, 'Summary', 'Detail')

    service.add_card(project_id, feature_id)

    feature = feature_repository.find(project_id, feature_id)
    expect(feature.state).to eq(Feature::State::Wip)
  end
end
