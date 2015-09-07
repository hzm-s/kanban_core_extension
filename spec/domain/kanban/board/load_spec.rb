require 'rails_helper'

module Kanban
  describe 'load Board domain object' do
    before do
      board_record = Board.new(project_id_str: 'prj_789')
      board_record.cards.build(
        feature_id_str: 'feat_100',
        stage_phase_name: 'Todo',
        stage_state_name: ''
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

    describe 'Todo stage' do
      subject { board.fetch_card(FeatureId('feat_100'), Stage('Todo')) }

      it { is_expected.to be_truthy }
    end

    describe 'Dev-Doing stage' do
      subject { board.fetch_card(FeatureId('feat_200'), Stage('Dev', 'Doing')) }

      it { is_expected.to be_truthy }
    end
  end
end
