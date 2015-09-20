require 'rails_helper'

describe ForwardCardCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'no exception' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          feature_id_str: 'feat_123',
          step_phase_name: 'Dev',
          step_state_name: 'Doing',
        )
        expect(service)
          .to receive(:forward_card)
          .with(project_id, FeatureId('feat_123'), Step('Dev', 'Doing'))
        cmd.execute(service)
      end
    end

    context 'given feature_id_str = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          feature_id_str: '',
          step_phase_name: 'Dev',
          step_state_name: 'Doing',
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given step_phase_name = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          feature_id_str: 'feat_123',
          step_phase_name: '',
          step_state_name: 'Doing',
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Project::WipLimitReached' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          feature_id_str: 'feat_123',
          step_phase_name: 'Dev',
          step_state_name: 'Doing',
        )
        allow(service).to receive(:forward_card).and_raise(Project::WipLimitReached)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
