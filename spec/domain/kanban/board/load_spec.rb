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
      let(:stage) { board.staged_card(Stage('Todo', nil)) }

      it { expect(stage).to include(FeatureId('feat_100')) }
    end

    describe 'Dev-Doing stage' do
      let(:stage) { board.staged_card(Stage('Dev', 'Doing')) }

      it { expect(stage).to include(FeatureId('feat_200')) }
    end
  end
end
