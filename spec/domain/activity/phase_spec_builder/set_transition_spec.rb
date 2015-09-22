require 'rails_helper'

module Activity
  describe PhaseSpecBuilder do
    describe '#set_transition' do
      let(:factory) { described_class.new(current) }
      let(:new_phase_spec) { factory.build_phase_spec }

      context 'no transition' do
        let(:current) do
          PhaseSpec(phase: 'Dev', transition: nil, wip_limit: 2)
        end

        context 'set Doing|Done' do
          it do
            factory.set_transition([State('Doing'), State('Done')])
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2)
            )
          end
        end

        context 'set Doing|Done|Doing' do
          it do
            factory.set_transition([State('Doing'), State('Done'), State('Doing')])
            expect { new_phase_spec }.to raise_error(DuplicateState)
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

        it do
          expect {
            factory.set_transition([State('Doing'), State('Done')])
          }.to raise_error(TransitionAlreadySetted)
        end
      end
    end
  end
end
