require 'rails_helper'

describe AddStateCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:phase_spec_service) }

  describe '#execute' do
    context 'state_name = Review position = before base_state_name = Done' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_name: 'Review',
          position: 'before',
          base_state_name: 'Done'
        )
        expect(service).to receive(:add_state).with(
          project_id,
          Phase('Dev'),
          State('Review'),
          { before: State('Done') }
        )
        cmd.execute(service)
      end
    end

    context 'state_name = Review position = after base_state_name = Doing' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_name: 'Review',
          position: 'after',
          base_state_name: 'Doing'
        )
        expect(service).to receive(:add_state).with(
          project_id,
          Phase('Dev'),
          State('Review'),
          { after: State('Doing') }
        )
        cmd.execute(service)
      end
    end

    context 'state_name = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_name: ''
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'state_name = Review' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'Dev',
          state_name: 'Review'
        )
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

  describe '#describe' do
    context 'state_name = Review position = before base_state_name: Done' do
      it do
        cmd = described_class.new(
          phase_name: 'Dev',
          position: 'before',
          base_state_name: 'Done'
        )
        expect(cmd.describe).to eq('「Dev」フェーズの「Done」の前に状態を追加')
      end
    end
  end

  describe '#describe' do
    context 'state_name = Review position = after base_state_name: Doing' do
      it do
        cmd = described_class.new(
          phase_name: 'Dev',
          position: 'after',
          base_state_name: 'Doing'
        )
        expect(cmd.describe).to eq('「Dev」フェーズの「Doing」の後に状態を追加')
      end
    end
  end
end
