require 'rails_helper'
require 'project/phase_spec'

describe RemoveStateCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'given phase = Dev state = Review' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: 'Dev',
          state_name: 'Review'
        )
        expect(service)
          .to receive(:remove_state)
          .with(project_id, Phase('Dev'), State('Review'))
        cmd.execute(service)
      end
    end

    context 'given phase = "" state = Review' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: '',
          state_name: 'Review'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given phase = Dev state = ""' do
      it do
        cmd = described_class.new(
          project_id_str: project_id.to_s,
          phase_name: 'Dev',
          state_name: ''
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'service raises Project::CardOnState' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: 'Todo')
        allow(service).to receive(:remove_phase_spec).and_raise(Project::CardOnState)
        expect(cmd.execute(service)).to be_falsey
      end
    end
  end
end
