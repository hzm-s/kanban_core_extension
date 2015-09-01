require 'rails_helper'

module Kanban
  describe Board do
    describe '#add_card' do
      let(:project_id) { Project::ProjectId.new('prj_123') }

      let(:board) do
        Board.new.tap do |board|
          board.prepare(project_id)
          board.save!
        end
      end

      it do
        feature_id = Project::FeatureId.new('feat_789')
        rule = double(:rule).tap do |d|
          d.stub(:initial_position) { Position('Todo', nil) }
          d.stub(:can_put_card?) { true }
        end

        board.add_card(feature_id, rule)

        card_record = board.card_records.where(feature_id_str: feature_id.to_s)
        expect(card_record).to_not be_nil
      end
    end
  end
end
