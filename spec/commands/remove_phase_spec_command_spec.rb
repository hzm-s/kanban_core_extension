require 'rails_helper'
require 'activity/workflow'

describe RemovePhaseSpecCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'given Todo' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: 'Todo')
        expect(service)
          .to receive(:remove_phase_spec)
          .with(project_id, Phase('Todo'))
        cmd.execute(service)
      end
    end

    context 'given ""' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: '')
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::NeedPhaseSpec' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: 'Todo')
        allow(service).to receive(:remove_phase_spec).and_raise(Activity::NeedPhaseSpec)
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::CardOnPhase' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: 'Todo')
        allow(service).to receive(:remove_phase_spec).and_raise(Activity::CardOnPhase)
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::PhaseNotFound' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: 'Todo')
        allow(service).to receive(:remove_phase_spec).and_raise(Activity::PhaseNotFound)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
