require 'rails_helper'
require 'activity/workflow'

describe DisableWipLimitCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'given phase = Next' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: 'Next'
        )
        expect(service)
          .to receive(:disable_wip_limit)
          .with(project_id, Phase('Next'))
        cmd.execute(service)
      end
    end

    context 'given phase = ""' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: ''
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::PhaseNotFound' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: 'Dev'
        )
        allow(service).to receive(:disable_wip_limit).and_raise(Activity::PhaseNotFound)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
