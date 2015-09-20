require 'rails_helper'

module Project
  describe 'load Project domain object' do
    before do
      project_record = ::Project::Project.new(
        project_id_str: 'prj_123',
        description_name: 'name',
        description_goal: 'goal'
      )
      project_record.phase_spec_records.build(
        order: 1,
        phase_name: 'Todo',
        wip_limit_count: nil
      )
      project_record.phase_spec_records.build(
        order: 2,
        phase_name: 'Dev',
        wip_limit_count: 2
      )
      project_record.state_records.build(
        order: 1,
        phase_name: 'Dev',
        state_name: 'Doing'
      )
      project_record.state_records.build(
        order: 2,
        phase_name: 'Dev',
        state_name: 'Done'
      )
      project_record.phase_spec_records.build(
        order: 3,
        phase_name: 'QA',
        wip_limit_count: 1
      )
      project_record.save!
    end

    let(:project) { ::Project::Project.last }

    describe 'ProjectId' do
      subject { project.project_id }
      it { is_expected.to eq(ProjectId.new('prj_123')) }
    end

    describe 'Description' do
      subject { project.description }
      it { is_expected.to eq(Description.new('name', 'goal')) }
    end

    describe 'Workflow#1' do
      subject { project.workflow.to_a[0] }
      it do
        is_expected.to eq(
          PhaseSpec.new(
            Phase.new('Todo'),
            NoTransition.new,
            NoWipLimit.new
          )
        )
      end
    end

    describe 'Workflow#2' do
      subject { project.workflow.to_a[1] }
      it do
        is_expected.to eq(
          PhaseSpec.new(
            Phase.new('Dev'),
            Transition.new([
              State.new('Doing'),
              State.new('Done'),
            ]),
            WipLimit.new(2)
          )
        )
      end
    end

    describe 'Workflow#3' do
      subject { project.workflow.to_a[2] }
      it do
        is_expected.to eq(
          PhaseSpec.new(
            Phase.new('QA'),
            NoTransition.new,
            WipLimit.new(1)
          )
        )
      end
    end
  end
end
