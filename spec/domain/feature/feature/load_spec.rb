require 'rails_helper'

module Feature
  describe 'load Feature domain model' do
    before do
      ::Feature::Feature.create!(
        project_id: project_id,
        feature_id_str: 'feat_123',
        number: 1,
        description_summary: 'Summary',
        description_detail: 'Detail'
      )
    end

    let(:feature) { ::Feature::Feature.last }
    let(:project_id) { ProjectId('prj_789') }

    describe 'Feature#project_id' do
      subject { feature.project_id }
      it { is_expected.to eq(project_id) }
    end

    describe 'Feature#feature_id' do
      subject { feature.feature_id }
      it { is_expected.to eq(FeatureId('feat_123')) }
    end

    describe 'Feature#number' do
      subject { feature.number }
      it { is_expected.to eq(1) }
    end

    describe 'Feature#description' do
      subject { feature.description }
      it { is_expected.to eq(Description.new('Summary', 'Detail')) }
    end
  end
end
