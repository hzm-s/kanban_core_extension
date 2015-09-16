require 'rails_helper'

describe RemovePhaseSpecCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'given Todo' do
      it do
        cmd = described_class.new(project_id_str: project_id.to_s, phase_name: 'Todo')
        expect(service)
          .to receive(:remove_phase_spec)
          .with(project_id, Phase('Todo'))
        cmd.execute(service)
      end
    end
  end
end
