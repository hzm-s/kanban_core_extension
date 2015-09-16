require 'rails_helper'

module Project
  describe Transition do
    describe '.new' do
      subject do
        described_class.new(states)
      end

      context 'given 2 states' do
        let(:states) { ['Doing', 'Done'].map {|n| State.new(n) } }
        it { is_expected.to eq(Transition.new(states)) }
      end

      context 'given 1 state' do
        let(:states) { [State.new('Doing')] }
        it do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
