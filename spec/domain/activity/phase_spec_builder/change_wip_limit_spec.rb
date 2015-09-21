require 'rails_helper'

module Activity
  describe PhaseSpecBuilder do
    describe '#change_wip_limit' do
      let(:factory) { described_class.new(current) }
      let(:new_phase_spec) { factory.build_phase_spec }
      let(:board) do
        Kanban::Board.new.tap {|b| b.prepare(ProjectId('prj_789')) }
      end

      context 'no state phase' do
        context 'wip = 1', 'change none => 1' do
          let(:current) do
            PhaseSpec(phase: 'Next', transition: nil, wip_limit: nil)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Next'))
            board.save!
          end

          it do
            factory.change_wip_limit(WipLimit(1), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Next', transition: nil, wip_limit: 1)
            )
          end
        end

        context 'wip = 1', 'change 1 => 2' do
          let(:current) do
            PhaseSpec(phase: 'Next', transition: nil, wip_limit: 1)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Next'))
            board.save!
          end

          it do
            factory.change_wip_limit(WipLimit(2), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Next', transition: nil, wip_limit: 2)
            )
          end
        end

        context 'wip = 1', 'change 2 => 1' do
          let(:current) do
            PhaseSpec(phase: 'Next', transition: nil, wip_limit: 2)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Next'))
            board.save!
          end

          it do
            factory.change_wip_limit(WipLimit(1), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Next', transition: nil, wip_limit: 1)
            )
          end
        end

        context 'wip = 2', 'change 2 => 1' do
          let(:current) do
            PhaseSpec(phase: 'Next', transition: nil, wip_limit: 2)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Next'))
            board.add_card(FeatureId('feat_567'), Step('Next'))
            board.save!
          end

          it do
            expect {
              factory.change_wip_limit(WipLimit(1), board)
            }.to raise_error(UnderCurrentWip)
          end
        end
      end

      context 'mulit state phase' do
        context 'wip = 2', 'change none => 2' do
          let(:current) do
            PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: nil)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Dev', 'Doing'))
            board.add_card(FeatureId('feat_567'), Step('Dev', 'Done'))
            board.save!
          end

          it do
            factory.change_wip_limit(WipLimit(2), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2)
            )
          end
        end

        context 'wip = 2', 'change 2 => 3' do
          let(:current) do
            PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Dev', 'Doing'))
            board.add_card(FeatureId('feat_567'), Step('Dev', 'Done'))
            board.save!
          end

          it do
            factory.change_wip_limit(WipLimit(3), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3)
            )
          end
        end

        context 'wip = 2', 'change 3 => 2' do
          let(:current) do
            PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 3)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Dev', 'Doing'))
            board.add_card(FeatureId('feat_567'), Step('Dev', 'Done'))
            board.save!
          end

          it do
            factory.change_wip_limit(WipLimit(2), board)
            expect(new_phase_spec).to eq(
              PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2)
            )
          end
        end

        context 'wip = 2', 'change 2 => 1' do
          let(:current) do
            PhaseSpec(phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2)
          end

          before do
            board.add_card(FeatureId('feat_123'), Step('Dev', 'Doing'))
            board.add_card(FeatureId('feat_567'), Step('Dev', 'Done'))
            board.save!
          end

          it do
            expect {
              factory.change_wip_limit(WipLimit(1), board)
            }.to raise_error(UnderCurrentWip)
          end
        end
      end
    end
  end
end
