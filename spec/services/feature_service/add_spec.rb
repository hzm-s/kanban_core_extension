require 'rails_helper'

describe 'add feature' do
  let(:service) do
    FeatureService.new(feature_repository)
  end
  let(:feature_repository) { FeatureRepository.new }

  let(:project_id) { Project('Name', 'Goal') }

  it do
    description = Feature::Description.new('Summary', 'Detail')

    feature_id = service.add(project_id, description)

    feature = feature_repository.find(project_id, feature_id)
    expect(feature).to_not be_nil
    expect(feature.number).to eq(1)
    expect(feature.description).to eq(description)
    expect(feature.state).to eq(Feature::State::Backlogged)
  end
end
