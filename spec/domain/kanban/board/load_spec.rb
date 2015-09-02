require 'rails_helper'

module Kanban
  describe Board do
    describe 'load domain object' do
      before do
        board_record = described_class.new(project_id_str: 'prj_789')
        board_record.cards.build(
          feature_id_str: 'feat_100',
          position_phase_name: 'Todo',
          position_state_name: nil
        )
        board_record.cards.build(
          feature_id_str: 'feat_200',
          position_phase_name: 'Dev',
          position_state_name: 'Doing'
        )
        board_record.save!
      end

      let(:board) { Board.last }

      describe 'Board#ProjectId' do
        subject { board.project_id }
        it { is_expected.to eq(Project::ProjectId.new('prj_789')) }
      end

      describe 'Card for feat_100' do
        let(:card) { board.get_card(Project::FeatureId.new('feat_100')) }

        describe 'position' do
          subject { card.position }
          it { is_expected.to eq(Position('Todo', nil)) }
        end
      end

      describe 'Card for feat_200' do
        let(:card) { board.get_card(Project::FeatureId.new('feat_200')) }

        describe 'position' do
          subject { card.position }
          it { is_expected.to eq(Position('Dev', 'Doing')) }
        end
      end
    end
  end
end
