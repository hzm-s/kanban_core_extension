require 'rails_helper'

module Kanban
  describe 'load Board domain object' do
    before do
      board_record = Board.new(project_id_str: 'prj_789')
      board_record.cards.build(
        feature_id_str: 'feat_100',
        stage_phase_name: 'Todo',
        stage_state_name: nil
      )
      board_record.cards.build(
        feature_id_str: 'feat_200',
        stage_phase_name: 'Dev',
        stage_state_name: 'Doing'
      )
      board_record.save!
    end

    let(:board) { Board.last }

    describe 'Board#ProjectId' do
      subject { board.project_id }
      it { is_expected.to eq(Project::ProjectId.new('prj_789')) }
    end

    describe 'Card for feat_100' do
      let(:card) { board.get_card(FeatureId('feat_100')) }

      describe 'stage' do
        subject { card.stage }
        it { is_expected.to eq(Stage('Todo', nil)) }
      end
    end

    describe 'Card for feat_200' do
      let(:card) { board.get_card(FeatureId('feat_200')) }

      describe 'stage' do
        subject { card.stage }
        it { is_expected.to eq(Stage('Dev', 'Doing')) }
      end
    end
  end
end
