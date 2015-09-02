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
          allow(d).to receive(:initial_position) { Position('Todo', nil) }
          allow(d).to receive(:can_put_card?) { true }
        end

        board.add_card(feature_id, rule)

        cards = board.cards.where(feature_id_str: feature_id.to_s)
        expect(cards).to_not be_nil
      end
    end
  end
end
