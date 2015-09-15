require 'rails_helper'

describe AddPhaseSpecCommand do
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
