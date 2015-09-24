require 'rails_helper'

module Kanban
  describe BoardMaintainer do
    let(:project_id) { ProjectId('prj_789') }
    let(:board_maintainer) { described_class.new(board_repository) }
    let(:board_repository) { BoardRepository.new }
    let(:board) { Kanban::Board.new.tap {|b| b.prepare(project_id) } }

    before { board.save! }

    describe '#transition_setted' do
      let(:old) { PhaseSpec(phase: 'Dev', transition: nil, wip_limit: nil) }
      let(:new) { PhaseSpec(phase: 'Dev', transition: %w(Doing Done), wip_limit: nil) }

      context 'cards = 0' do
        it do
          event = Activity::TransitionSetted.new(project_id, new, old)
          board_maintainer.transition_setted(event)

          board = board_repository.find(project_id)
          expect(board.count_card(new.phase)).to eq(0)
        end
      end

      context 'cards = 1' do
        before do
          board.add_card(feature1, Step('Dev'))
          board.add_card(feature2, Step('Dev'))
          board.add_card(feature3, Step('Dev'))
          board.save!
        end

        let(:feature1) { FeatureId('feat_1') }
        let(:feature2) { FeatureId('feat_2') }
        let(:feature3) { FeatureId('feat_3') }

        it do
          event = Activity::TransitionSetted.new(project_id, new, old)
          board_maintainer.transition_setted(event)

          board = board_repository.find(project_id)
          expect(board.fetch_card(feature1, new.first_step)).to_not be_nil
          expect(board.fetch_card(feature2, new.first_step)).to_not be_nil
          expect(board.fetch_card(feature3, new.first_step)).to_not be_nil
          expect(board.card_map.count_by_step(new.first_step)).to eq(3)
        end
      end
    end
  end
end
