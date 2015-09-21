require 'rails_helper'
require 'activity/workflow'
require 'activity/phase_spec'
require 'activity/phase_spec_factory'

describe RemoveStateCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'given phase = Dev state = Review' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: 'Dev',
          state_name: 'Review'
        )
        expect(service)
          .to receive(:remove_state)
          .with(project_id, Phase('Dev'), State('Review'))
        cmd.execute(service)
      end
    end

    context 'given phase = "" state = Review' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: '',
          state_name: 'Review'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given phase = Dev state = ""' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: 'Dev',
          state_name: ''
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::CardOnState' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s, phase_name: 'Dev', state_name: 'Review'
        )
        allow(service).to receive(:remove_state).and_raise(Activity::CardOnState)
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::NeedMoreThanOneState' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s, phase_name: 'Dev', state_name: 'Review'
        )
        allow(service).to receive(:remove_state).and_raise(Activity::NeedMoreThanOneState)
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::PhaseNotFound' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s, phase_name: 'Dev', state_name: 'Review'
        )
        allow(service).to receive(:remove_state).and_raise(Activity::PhaseNotFound)
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::StateNotFound' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s, phase_name: 'Dev', state_name: 'Review'
        )
        allow(service).to receive(:remove_state).and_raise(Activity::StateNotFound)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
