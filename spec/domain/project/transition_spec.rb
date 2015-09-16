require 'rails_helper'

module Project
  describe Transition do
    describe '.new' do
      subject do
        described_class.new(states)
      end

      let(:states) { state_names.map {|n| State.new(n) } }

      context 'given 2 state names' do
        let(:state_names) { ['Doing', 'Done'] }
        it { is_expected.to eq(Transition(state_names)) }
      end

      context 'given 1 state name' do
        let(:state_names) { ['Doing'] }
        it do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
