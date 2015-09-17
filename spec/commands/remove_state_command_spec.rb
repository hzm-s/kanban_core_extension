require 'rails_helper'

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
  end
end
