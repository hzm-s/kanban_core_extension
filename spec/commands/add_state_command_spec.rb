require 'rails_helper'

describe AddStateCommand do
  describe '#execute' do
    context 'state_name:Doing' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_name: 'Doing'
        )
        service = double(:workflow_service)
        expect(service).to receive(:add_state).with(
          ProjectId('prj_789'),
          Phase('Dev'),
          State('Doing')
        )
        cmd.execute(service)
      end
    end

    context 'state_name:""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_name: ''
        )
        service = double(:workflow_service)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end

  describe '#state' do
    it do
      cmd = described_class.new(state_name: 'Doing')
      expect(cmd.state).to eq(State('Doing'))
    end
  end

  describe '#phase' do
    it do
      cmd = described_class.new(phase_name: 'Dev')
      expect(cmd.phase).to eq(Phase('Dev'))
    end
  end
end
