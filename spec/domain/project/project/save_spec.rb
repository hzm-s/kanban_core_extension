require 'rails_helper'

module Project
  describe Project do
    describe '#save!' do
      before do
        project.specify_workflow(workflow)
        project.save!
      end

      let(:project_id) { ProjectId.new('prj_123') }

      let(:project) do
        ::Project::Project.new.tap do |project|
          project.project_id = project_id
          project.description = Description.new('name', 'goal')
        end
      end

      context 'NO wip_limit, NO states' do
        let(:workflow) do
          Workflow.new([
            PhaseSpec.new(
              Phase.new('Todo'),
              Transition::None.new,
              WipLimit::None.new
            )
          ])
        end

        it do
          project_record = ::Project::Project.find_by(project_id_str: project_id.to_s)
          expect(project_record).to_not be_nil

          phase_spec_record = project_record.phase_spec_records.where(order: 1).first
          expect(phase_spec_record.phase_name).to eq('Todo')
          expect(phase_spec_record.wip_limit_count).to be_nil

          expect(project_record.state_records).to be_empty
        end
      end

      context 'NO wip_limit, states are Doing Done' do
        let(:workflow) do
          Workflow.new([
            PhaseSpec.new(
              Phase.new('Todo'),
              Transition.new([State.new('Doing'), State.new('Done')]),
              WipLimit::None.new
            )
          ])
        end

        it do
          project_record = ::Project::Project.find_by(project_id_str: project_id.to_s)
          expect(project_record).to_not be_nil

          phase_spec_record = project_record.phase_spec_records.where(order: 1).first
          expect(phase_spec_record.phase_name).to eq('Todo')
          expect(phase_spec_record.wip_limit_count).to be_nil

          state_record1 = project_record.state_records.where(order: 1).first
          expect(state_record1.phase_name).to eq('Todo')
          expect(state_record1.state_name).to eq('Doing')

          state_record2 = project_record.state_records.where(order: 2).first
          expect(state_record2.phase_name).to eq('Todo')
          expect(state_record2.state_name).to eq('Done')
        end
      end

      context 'wip_limit = 10, NO states' do
        let(:workflow) do
          Workflow.new([
            PhaseSpec.new(
              Phase.new('Todo'),
              Transition::None.new,
              WipLimit.new(10)
            )
          ])
        end

        it do
          project_record = ::Project::Project.find_by(project_id_str: project_id.to_s)
          expect(project_record).to_not be_nil

          phase_spec_record = project_record.phase_spec_records.where(order: 1).first
          expect(phase_spec_record.phase_name).to eq('Todo')
          expect(phase_spec_record.wip_limit_count).to eq(10)

          expect(project_record.state_records).to be_empty
        end
      end

      context 'wip_limit = 10, states are Doing Done' do
        let(:workflow) do
          Workflow.new([
            PhaseSpec.new(
              Phase.new('Todo'),
              Transition.new([State.new('Doing'), State.new('Done')]),
              WipLimit.new(10)
            )
          ])
        end

        it do
          project_record = ::Project::Project.find_by(project_id_str: project_id.to_s)
          expect(project_record).to_not be_nil

          phase_spec_record = project_record.phase_spec_records.where(order: 1).first
          expect(phase_spec_record.phase_name).to eq('Todo')
          expect(phase_spec_record.wip_limit_count).to eq(10)

          state_record1 = project_record.state_records.where(order: 1).first
          expect(state_record1.phase_name).to eq('Todo')
          expect(state_record1.state_name).to eq('Doing')

          state_record2 = project_record.state_records.where(order: 2).first
          expect(state_record2.phase_name).to eq('Todo')
          expect(state_record2.state_name).to eq('Done')
        end
      end
    end
  end
end
