require 'rails_helper'

describe SetTransitionCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#transition' do
    context 'given Doing, Done' do
      it do
        cmd = described_class.new(state_names: ['Doing', 'Done'])
        expect(cmd.transition).to eq(Transition(['Doing', 'Done']))
      end
    end
  end

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
            Transition(['Doing', 'Done'])
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
  end
end
