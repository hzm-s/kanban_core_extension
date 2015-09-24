require 'rails_helper'

module Activity
  describe PhaseSpecBuilder do
    describe '#set_transition' do
      subject do
        factory.set_transition(transition)
      end

      let(:factory) { described_class.new(current) }
      let(:built) { factory.build_phase_spec }

      context 'no transition' do
        let(:current) do
          PhaseSpec(phase: 'Dev', transition: nil, wip_limit: 2)
        end

        context 'set Doing|Done' do
          let(:transition) { [State('Doing'), State('Done')] }

          it do
            subject
            expect(built).to eq(
              PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2)
            )
          end
        end

        context 'set Doing|Done|Doing' do
          let(:transition) { [State('Doing'), State('Done'), State('Doing')] }

          it do
            subject
            expect { built }.to raise_error(DuplicateState)
          end
        end
      end

      context 'transition already setted' do
        let(:current) do
          PhaseSpec(
            phase: 'Dev',
            transition: ['Doing', 'Review', 'Done'],
            wip_limit: 2
          )
        end

        let(:transition) { [State('Doing'), State('Done')] }

        it do
          expect { subject }.to raise_error(TransitionAlreadySetted)
        end
      end
    end
  end
end
