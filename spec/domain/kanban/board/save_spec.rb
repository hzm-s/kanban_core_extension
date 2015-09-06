require 'rails_helper'

module Kanban
  describe 'save Board as active record' do
    let(:rule) do
      Rule.new(
        Workflow([
          { phase: 'Todo' },
          { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
          { phase: 'QA', wip_limit: 1 }
        ])
      )
    end

    before do
      Board.new.tap do |board|
        board.prepare(Project::ProjectId.new('prj_789'))
        board.save!

        board.add_card(FeatureId('feat_100'), rule)
        board.add_card(FeatureId('feat_200'), rule)
        board.add_card(FeatureId('feat_300'), rule)
        board.save!

        board.forward_card(FeatureId('feat_200'), Stage('Todo', nil), rule)
        board.forward_card(FeatureId('feat_300'), Stage('Todo', nil), rule)

        board.forward_card(FeatureId('feat_300'), Stage('Dev', 'Doing'), rule)
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

      describe 'stage_phase_name' do
        subject { card_record.stage_phase_name }
        it { is_expected.to eq('Todo') }
      end

      describe 'stage_state_name' do
        subject { card_record.stage_state_name }
        it { is_expected.to be_blank }
      end
    end

    describe 'CardRecord for feat_200' do
      let(:card_record) do
        board_record.cards.where(feature_id_str: 'feat_200').first
      end

      describe 'stage_phase_name' do
        subject { card_record.stage_phase_name }
        it { is_expected.to eq('Dev') }
      end

      describe 'stage_state_name' do
        subject { card_record.stage_state_name }
        it { is_expected.to eq('Doing') }
      end
    end

    describe 'CardRecord for feat_300' do
      let(:card_record) do
        board_record.cards.where(feature_id_str: 'feat_300').first
      end

      describe 'stage_phase_name' do
        subject { card_record.stage_phase_name }
        it { is_expected.to eq('Dev') }
      end

      describe 'stage_state_name' do
        subject { card_record.stage_state_name }
        it { is_expected.to eq('Done') }
      end
    end
  end
end
