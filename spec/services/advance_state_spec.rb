require 'rails_helper'

describe 'advance state' do
  include GroupCreator

  let(:service) do
    FeatureService.new(group_repository)
  end
  let(:group_repository) { FakeGroupRepository.new }

  before do
    group_repository.store(group)
  end

  let(:project_id) { 'prj_1' }

  let(:feature_id) { FeatureId('feat_123') }

  context 'phase = Doing|Review|Done current = Doing' do
    let(:group) do
      Group(
        project_id: project_id,
        phase: 'Dev',
        wip_limit: 2,
        transition: %w(Doing Review Done),
        work_list: [Work(feature_id, State('Doing'))]
      )
    end

    it do
      phase = Phase('Dev')

      service.advance_state(project_id, feature_id, phase)

      group = group_repository.find(project_id, phase)
      expect(group.work_list).to eq(
        WorkList([Work(feature_id, State('Review'))])
      )
    end
  end
end
