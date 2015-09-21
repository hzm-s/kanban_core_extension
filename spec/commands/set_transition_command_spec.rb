require 'rails_helper'
require 'activity/phase_spec_builder'

describe SetTransitionCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:phase_spec_service) }

  describe '#execute' do
    context 'given Doing, Done' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_names: ['Doing', 'Done']
        )
        expect(service)
          .to receive(:set_transition)
          .with(
            project_id,
            Phase('Dev'),
            [State('Doing'), State('Done')]
          )
        cmd.execute(service)
      end
    end

    context 'given empty' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_names: ['', '']
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given Doing' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_names: ['Doing']
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::DuplicateState' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_names: ['Doing', 'Doing']
        )
        allow(service)
          .to receive(:set_transition).and_raise(Activity::DuplicateState)
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Activity::DuplicateState' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_names: ['Doing', 'Done']
        )
        allow(service)
          .to receive(:set_transition).and_raise(Activity::TransitionAlreadySetted)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
