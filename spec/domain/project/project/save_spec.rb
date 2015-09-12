require 'rails_helper'

module Project
  describe 'save Project as active record' do
    before do
      project = ::Project::Project.new.tap do |project|
        project.project_id = ProjectId.new('prj_123')
        project.description = Description.new('name', 'goal')
      end

      workflow = Workflow([
        { phase: 'Todo' },
        { phase: 'Dev', transition: ['Doing', 'Done'], wip_limit: 2 },
        { phase: 'QA', wip_limit: 1 }
      ])
      project.specify_workflow(workflow)
      project.save!
    end

    let(:project_record) { ::Project::Project.last }

    describe 'ProjectRecord', 'project_id_str' do
      subject { project_record.project_id_str }
      it { is_expected.to eq('prj_123') }
    end

    describe 'ProjectRecord', 'description_name' do
      subject { project_record.description_name }
      it { is_expected.to eq('name') }
    end

    describe 'ProjectRecord', 'description_goal' do
      subject { project_record.description_goal }
      it { is_expected.to eq('goal') }
    end

    describe 'PhaseSpecRecord#1' do
      let(:record) { project_record.phase_spec_records.where(order: 1).first }

      describe 'phase_name' do
        subject { record.phase_name }
        it { is_expected.to eq('Todo') }
      end

      describe 'wip_limit_count' do
        subject { record.wip_limit_count }
        it { is_expected.to be_nil }
      end
    end

    describe 'PhaseSpecRecord#2' do
      let(:record) { project_record.phase_spec_records.where(order: 2).first }

      describe 'phase_name' do
        subject { record.phase_name }
        it { is_expected.to eq('Dev') }
      end

      describe 'wip_limit_count' do
        subject { record.wip_limit_count }
        it { is_expected.to eq(2) }
      end
    end

    describe 'PhaseSpecRecord#3' do
      let(:record) { project_record.phase_spec_records.where(order: 3).first }

      describe 'phase_name' do
        subject { record.phase_name }
        it { is_expected.to eq('QA') }
      end

      describe 'wip_limit_count' do
        subject { record.wip_limit_count }
        it { is_expected.to eq(1) }
      end
    end

    describe 'StateRecords for Todo' do
      subject do
        project_record.state_records.where(phase_name: 'Todo')
      end
      it { is_expected.to be_empty }
    end

    describe 'StateRecord for Dev #1' do
      let(:record) do
        project_record.state_records.where(phase_name: 'Dev', order: 1).first
      end

      describe 'state_name' do
        subject { record.state_name }
        it { is_expected.to eq('Doing') }
      end
    end

    describe 'StateRecord for Dev #2' do
      let(:record) do
        project_record.state_records.where(phase_name: 'Dev', order: 2).first
      end

      describe 'state_name' do
        subject { record.state_name }
        it { is_expected.to eq('Done') }
      end
    end

    describe 'StateRecords for QA' do
      subject do
        project_record.state_records.where(phase_name: 'QA')
      end
      it { is_expected.to be_empty }
    end
  end
end
