require 'rails_helper'

module Kanban
  describe 'save Board as active record' do
    before do
      Board.new.tap do |board|
        board.prepare(Project::ProjectId.new('prj_789'))
        board.save!

        board.add_card(FeatureId('feat_100'), Step('Todo'))
        board.add_card(FeatureId('feat_200'), Step('Todo'))
        board.add_card(FeatureId('feat_300'), Step('Todo'))
        board.add_card(FeatureId('feat_400'), Step('Todo'))
        board.save!

        board.move_card(FeatureId('feat_200'), Step('Todo'), Step('Dev', 'Doing'))
        board.move_card(FeatureId('feat_300'), Step('Todo'), Step('Dev', 'Done'))
        board.remove_card(FeatureId('feat_400'), Step('Todo'))
        board.save!
      end
    end

    let(:board_record) { Kanban::Board.last }

    describe 'BoardRecord', 'project_id_str' do
      subject { board_record.project_id_str }
      it { is_expected.to eq('prj_789') }
    end

    describe 'CardRecord for feat_100' do
      let(:card_record) do
        board_record.cards.where(feature_id_str: 'feat_100').first
      end

      describe 'step_phase_name' do
        subject { card_record.step_phase_name }
        it { is_expected.to eq('Todo') }
      end

      describe 'step_state_name' do
        subject { card_record.step_state_name }
        it { is_expected.to eq('') }
      end
    end

    describe 'CardRecord for feat_200' do
      let(:card_record) do
        board_record.cards.where(feature_id_str: 'feat_200').first
      end

      describe 'step_phase_name' do
        subject { card_record.step_phase_name }
        it { is_expected.to eq('Dev') }
      end

      describe 'step_state_name' do
        subject { card_record.step_state_name }
        it { is_expected.to eq('Doing') }
      end
    end

    describe 'CardRecord for feat_300' do
      let(:card_record) do
        board_record.cards.where(feature_id_str: 'feat_300').first
      end

      describe 'step_phase_name' do
        subject { card_record.step_phase_name }
        it { is_expected.to eq('Dev') }
      end

      describe 'step_state_name' do
        subject { card_record.step_state_name }
        it { is_expected.to eq('Done') }
      end
    end

    describe 'CardRecord for feat_400' do
      let(:card_record) do
        board_record.cards.where(feature_id_str: 'feat_400').first
      end

      it { expect(card_record).to be_nil }
    end
  end
end
