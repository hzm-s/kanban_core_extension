require 'rails_helper'

describe AddFeatureCommand do
  let(:project_id) { ProjectId('prj_789') }
  let(:service) { double(:workflow_service) }

  describe '#execute' do
    context 'given summary = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          summary: '',
          detail: 'Detail'
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'given detail = ""' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          summary: 'Summary',
          detail: ''
        )
        expect(cmd.execute(service)).to be_falsey
      end
    end

    context 'no exceptions' do
      it do
        cmd = described_class.new(
          project_id_str: 'prj_789',
          summary: 'Summary',
          detail: 'Detail'
        )
        expect(service)
          .to receive(:add)
          .with(
            project_id,
            Feature::Description.new('Summary', 'Detail')
          )
        cmd.execute(service)
      end
    end
  end
end
