require 'rails_helper'

describe AddCardCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'available for more wip' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          feature_id_str: 'feat_123'
        )
        expect(service)
          .to receive(:add_card)
          .with(project_id, FeatureId('feat_123'))
        cmd.execute(service)
      end
    end

    context 'service raises Activity::WipLimitReached' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          feature_id_str: 'feat_123'
        )
        allow(service).to receive(:add_card).and_raise(Activity::WipLimitReached)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
