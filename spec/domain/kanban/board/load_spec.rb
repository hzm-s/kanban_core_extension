require 'rails_helper'

module Kanban
  describe 'load Board domain object' do
    before do
      board_record = Board.new(project_id_str: 'prj_789')
      board_record.cards.build(
        feature_id_str: 'feat_100',
        step_phase_name: 'Todo',
        step_state_name: ''
      )
      board_record.cards.build(
        feature_id_str: 'feat_200',
        step_phase_name: 'Dev',
        step_state_name: 'Doing'
      )
      board_record.save!
    end

    let(:board) { Board.last }

    describe 'Board#ProjectId' do
      subject { board.project_id }
      it { is_expected.to eq(Project::ProjectId.new('prj_789')) }
    end

    describe 'Todo step' do
      subject { board.fetch_card(FeatureId('feat_100'), Step('Todo')) }

      it { is_expected.to be_truthy }
    end

    describe 'Dev-Doing step' do
      subject { board.fetch_card(FeatureId('feat_200'), Step('Dev', 'Doing')) }

      it { is_expected.to be_truthy }
    end
  end
end
