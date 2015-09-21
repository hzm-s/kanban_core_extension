require 'rails_helper'

module Activity
  describe PhaseSpecBuilder do
    describe '#remove_state' do
      let(:factory) { described_class.new(current) }
      let(:new_phase_spec) { factory.build_phase_spec }
      let(:board) do
        Kanban::Board.new.tap {|b| b.prepare(ProjectId('prj_789')) }
      end

      context 'current = Doing|Review|Done' do
        let(:current) do
          PhaseSpec(
            phase: 'Dev',
            transition: ['Doing', 'Review', 'Done'],
            wip_limit: nil
          )
        end

        context 'no card' do
          it do
            factory.remove_state(State('Review'), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(
                phase: 'Dev',
                transition: ['Doing', 'Done'],
                wip_limit: nil
              )
            )
          end
        end

        context 'card on Doing' do
          before do
            board.add_card(FeatureId('feat_1'), Step('Dev', 'Doing'))
            board.save!
          end

          it do
            factory.remove_state(State('Review'), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(
                phase: 'Dev',
                transition: ['Doing', 'Done'],
                wip_limit: nil
              )
            )
          end
        end

        context 'card on Review' do
          before do
            board.add_card(FeatureId('feat_1'), Step('Dev', 'Review'))
            board.save!
          end

          it do
            expect {
              factory.remove_state(State('Review'), board)
            }.to raise_error(CardOnState)
          end
        end

        context 'card on Done' do
          before do
            board.add_card(FeatureId('feat_1'), Step('Dev', 'Done'))
            board.save!
          end

          it do
            factory.remove_state(State('Review'), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(
                phase: 'Dev',
                transition: ['Doing', 'Done'],
                wip_limit: nil
              )
            )
          end
        end

        context 'remove None' do
          it do
            expect { factory.remove_state(State('None'), board) }
              .to raise_error(StateNotFound)
          end
        end
      end

      context 'states = Doing|Done' do
        let(:current) do
          PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: nil)
        end

        it do
          factory.remove_state(State('Doing'), board)
          expect { new_phase_spec }.to raise_error(NeedMoreThanOneState)
        end

        it do
          factory.remove_state(State('Done'), board)
          expect { new_phase_spec }.to raise_error(NeedMoreThanOneState)
        end
      end
    end
  end
end
