require 'rails_helper'

describe AddPhaseSpecCommand do
  describe '#phase_spec' do
    context 'wip_limit=3, states=none' do
      it do
        cmd = described_class.new(
          phase_name: 'New Phase',
          wip_limit_count: 3
        )
        expect(cmd.phase_spec).to eq(
          Project::PhaseSpec.new(
            Project::Phase.new('New Phase'),
            Project::Transition::None.new,
            Project::WipLimit.new(3)
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
          Project::PhaseSpec.new(
            Project::Phase.new('New Phase'),
            Project::Transition::None.new,
            Project::WipLimit::None.new
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
          Project::PhaseSpec.new(
            Project::Phase.new('New Phase'),
            Project::Transition.new([
              Project::State.new('Doing'),
              Project::State.new('Done')
            ]),
            Project::WipLimit.new(3)
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
          Project::PhaseSpec.new(
            Project::Phase.new('New Phase'),
            Project::Transition.new([
              Project::State.new('Doing'),
              Project::State.new('Done')
            ]),
            Project::WipLimit::None.new
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
          Project::PhaseSpec.new(
            Project::Phase.new('New Phase'),
            Project::Transition.new([
              Project::State.new('Doing'),
              Project::State.new('Done')
            ]),
            Project::WipLimit.new(3)
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
        { direction: 'before', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq({ before: Phase('Dev') }) }
    end

    context 'insert after' do
      let(:params) do
        { direction: 'after', base_phase_name: 'Dev' }
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
        { direction: 'before', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq('「Dev」の前に新しいフェーズを追加') }
    end

    context 'insert after' do
      let(:params) do
        { direction: 'after', base_phase_name: 'Dev' }
      end
      it { is_expected.to eq('「Dev」の後に新しいフェーズを追加') }
    end

    context 'add to last' do
      let(:params) { nil }
      it { is_expected.to eq('新しいフェーズを追加') }
    end
  end
end
