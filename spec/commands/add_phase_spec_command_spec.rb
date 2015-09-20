require 'rails_helper'

describe AddPhaseSpecCommand do
  describe '#execute' do
    let(:service) { double(:workflow_service) }

    context 'wip_limit = 2, states = none, before: Todo' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'New Phase',
          wip_limit_count: 2,
          state_names: [''],
          position: 'before',
          base_phase_name: 'Todo'
        )
        expect(service)
          .to receive(:add_phase_spec)
          .with(
            ProjectId('prj_789'),
            PhaseSpec(phase: 'New Phase', wip_limit: 2),
            { before: Phase('Todo') }
          )
        cmd.execute(service)
      end
    end

    context 'wip_limit = 2, states = Doing|Done, after: Todo' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'New Phase',
          wip_limit_count: 2,
          state_names: ['Doing', 'Done'],
          position: 'after',
          base_phase_name: 'Todo'
        )
        expect(service)
          .to receive(:add_phase_spec)
          .with(
            ProjectId('prj_789'),
            PhaseSpec(phase: 'New Phase', transition: ['Doing', 'Done'], wip_limit: 2),
            { after: Phase('Todo') }
          )
        cmd.execute(service)
      end
    end

    context 'wip_limit = 2, states = Doing, before: Todo' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          phase_name: 'New Phase',
          wip_limit_count: 2,
          state_names: ['Doing'],
          position: 'before',
          base_phase_name: 'Todo'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end

  describe '#phase_spec' do
    context 'wip_limit=3, states=none' do
      it do
        cmd = described_class.new(
          phase_name: 'New Phase',
          wip_limit_count: 3
        )
        expect(cmd.phase_spec).to eq(
          Activity::PhaseSpec.new(
            Activity::Phase.new('New Phase'),
            Activity::NoTransition.new,
            Activity::WipLimit.new(3)
          )
        )
      end
    end

    context 'wip_limit=none, states=none' do
      it do
        cmd = described_class.new(
          phase_name: 'New Phase',
          wip_limit_count: ''
        )
        expect(cmd.phase_spec).to eq(
          Activity::PhaseSpec.new(
            Activity::Phase.new('New Phase'),
            Activity::NoTransition.new,
            Activity::NoWipLimit.new
          )
        )
      end
    end

    context 'wip_limit=3, states=Doing, Done' do
      it do
        cmd = described_class.new(
          phase_name: 'New Phase',
          wip_limit_count: 3,
          state_names: ['Doing', 'Done']
        )
        expect(cmd.phase_spec).to eq(
          Activity::PhaseSpec.new(
            Activity::Phase.new('New Phase'),
            Activity::Transition.new([
              Activity::State.new('Doing'),
              Activity::State.new('Done')
            ]),
            Activity::WipLimit.new(3)
          )
        )
      end
    end

    context 'wip_limit=none, states=Doing, Done' do
      it do
        cmd = described_class.new(
          phase_name: 'New Phase',
          wip_limit_count: '',
          state_names: ['Doing', 'Done']
        )
        expect(cmd.phase_spec).to eq(
          Activity::PhaseSpec.new(
            Activity::Phase.new('New Phase'),
            Activity::Transition.new([
              Activity::State.new('Doing'),
              Activity::State.new('Done')
            ]),
            Activity::NoWipLimit.new
          )
        )
      end
    end

    context 'wip_limit=3, states=Doing, "", Done' do
      it do
        cmd = described_class.new(
          phase_name: 'New Phase',
          wip_limit_count: 3,
          state_names: ['Doing', '', 'Done']
        )
        expect(cmd.phase_spec).to eq(
          Activity::PhaseSpec.new(
            Activity::Phase.new('New Phase'),
            Activity::Transition.new([
              Activity::State.new('Doing'),
              Activity::State.new('Done')
            ]),
            Activity::WipLimit.new(3)
          )
        )
      end
    end
  end

  describe '#position_option' do
    subject do
      described_class.new(params).position_option
    end

    context 'insert before' do
      let(:params) do
        { position: 'before', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq({ before: Phase('Dev') }) }
    end

    context 'insert after' do
      let(:params) do
        { position: 'after', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq({ after: Phase('Dev') }) }
    end

    context 'add to last' do
      let(:params) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#describe' do
    subject do
      described_class.new(params).describe
    end

    context 'insert before' do
      let(:params) do
        { position: 'before', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq('「Dev」の前に新しいフェーズを追加') }
    end

    context 'insert after' do
      let(:params) do
        { position: 'after', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq('「Dev」の後に新しいフェーズを追加') }
    end

    context 'add to last' do
      let(:params) { nil }
      it { is_expected.to eq('新しいフェーズを追加') }
    end
  end
end
