require 'rails_helper'

module Feature
  describe 'save as active record' do
    before do
      ::Feature::Feature.new.tap do |feature|
        feature.project_id = Project::ProjectId.new('prj_789')
        feature.feature_id = FeatureId('feat_123')
        feature.number = 1
        feature.description = Description.new('Summary', 'Detail')
        feature.save!
      end
    end

    let(:feature_record) { ::Feature::Feature.last }
    let(:project_id) { ProjectId('prj_789') }
    let(:feature_id) { FeatureId('feat_123') }

    describe 'FeatureRecord', 'project_id' do
      subject { feature_record.project_id }
      it { is_expected.to eq(project_id) }
    end

    describe 'FeatureRecord', 'feature_id' do
      subject { feature_record.feature_id }
      it { is_expected.to eq(feature_id) }
    end

    describe 'FeatureRecord', 'number' do
      subject { feature_record.number }
      it { is_expected.to eq(1) }
    end

    describe 'FeatureRecord', 'description_summary' do
      subject { feature_record.description_summary }
      it { is_expected.to eq('Summary') }
    end

    describe 'FeatureRecord', 'description_detail' do
      subject { feature_record.description_detail }
      it { is_expected.to eq('Detail') }
    end
  end
end
