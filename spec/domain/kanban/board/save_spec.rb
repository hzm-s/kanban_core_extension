require 'rails_helper'

module Kanban
  describe Board do
    describe '#save!' do
      subject do
        described_class
          .new
          .tap {|board| board.prepare(project_id) }
          .save!
        described_class.find_by(project_id_str: project_id.to_s)
      end

      let(:project_id) { Project::ProjectId.new('prj_123') }

      it { is_expected.to_not be_nil }
    end
  end
end
