require 'rails_helper'

module Activity
  describe PhaseSpecBuilder do
    describe '#disable_wip_limit' do
      let(:factory) { described_class.new(current) }
      let(:new_phase_spec) { factory.build_phase_spec }
      let(:board) do
        Kanban::Board.new.tap {|b| b.prepare(ProjectId('prj_789')) }
      end

      context 'no card' do
        let(:current) { PhaseSpec(phase: 'Next', transition: nil, wip_limit: 3) }

        it do
          factory.disable_wip_limit
          expect(new_phase_spec).to eq(
            PhaseSpec(phase: 'Next', transition: nil, wip_limit: nil)
          )
        end
      end

      context 'cards on phase' do
        let(:current) do
          PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3)
        end

        before do
          board.add_card(FeatureId('feat_100'), Step('Dev', 'Doing'))
          board.add_card(FeatureId('feat_200'), Step('Dev', 'Done'))
        end

        it do
          factory.disable_wip_limit
          expect(new_phase_spec).to eq(
            PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: nil)
          )
        end
      end
    end
  end
end
