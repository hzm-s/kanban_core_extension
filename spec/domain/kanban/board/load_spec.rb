require 'rails_helper'

module Kanban
  describe 'load Board domain object' do
    before do
      board_record = Board.new(project_id: project_id)
      board_record.cards.build(
        feature_id: FeatureId('feat_100'),
        step_phase_name: 'Todo',
        step_state_name: ''
      )
      board_record.cards.build(
        feature_id: FeatureId('feat_200'),
        step_phase_name: 'Dev',
        step_state_name: 'Doing'
      )
      board_record.save!
    end

    let(:board) { Board.last }
    let(:project_id) { Project::ProjectId.new('prj_789') }

    describe 'Board#ProjectId' do
      subject { board.project_id }
      it { is_expected.to eq(project_id) }
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
