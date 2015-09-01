require 'rails_helper'

module Kanban
  describe Board do
    describe '.save!' do
      subject do
        described_class.find_by(project_id_str: project_id.to_s)
      end

      before do
        workflow
          .build_board_with(builder)
          .save!
      end

      let(:project_id) { Project::ProjectId.new('prj_123') }
      let(:builder) { Kanban::BoardBuilder.new(project_id) }

      let(:workflow) do
        Project::Workflow.new([
          Project::PhaseSpec.new(
            Project::Phase.new('Todo'),
            Project::Transition::None.new,
            Project::WipLimit.new(10)
          ),
          Project::PhaseSpec.new(
            Project::Phase.new('Dev'),
            Project::Transition.new([
              Project::State.new('Doing'),
              Project::State.new('Done')
            ]),
            Project::WipLimit.new(2)
          ),
          Project::PhaseSpec.new(
            Project::Phase.new('QA'),
            Project::Transition::None.new,
            Project::WipLimit.new(1)
          )
        ])
      end

      it { is_expected.to_not be_nil }
    end
  end
end
