require 'rails_helper'

module Work
  describe GroupActivity do
    let(:multi_state) do
      Transition.new([State.new('Doing'), State.new('Review'), State.new('Done')])
    end

    describe '#add' do
      it do
        activity = GroupActivity.new(Phase.new('Dev'), multi_state)
        feature = Feature::FeatureId.new('feat_1')

        activity.add(feature, multi_state.first)

        expect(activity.to_h).to eq({
          'Doing' => ['feat_1'],
          'Review' => [],
          'Done' => [],
        })
      end

      it do
        activity = GroupActivity.new(Phase.new('Dev'), multi_state)
        feature = Feature::FeatureId.new('feat_1')
        activity.add(feature, multi_state.first)

        expect {
          activity.add(feature, multi_state.first)
        }.to raise_error(AlreadyWorked)
      end
    end

    describe '#progress' do
      it do
        activity = GroupActivity.new(Phase.new('Dev'), multi_state)
        feature = Feature::FeatureId.new('feat_1')
        activity.add(feature, multi_state.first)

        activity.progress(feature, multi_state.first, State.new('Review'))

        expect(activity.to_h).to eq({
          'Doing' => [],
          'Review' => ['feat_1'],
          'Done' => [],
        })
      end

      it do
        activity = GroupActivity.new(Phase.new('Dev'), multi_state)
        feature = Feature::FeatureId.new('feat_1')
        activity.add(feature, multi_state.first)
        activity.progress(feature, multi_state.first, State.new('Review'))

        activity.progress(feature, State.new('Review'), State.new('Done'))

        expect(activity.to_h).to eq({
          'Doing' => [],
          'Review' => [],
          'Done' => ['feat_1'],
        })
      end

      it do
        activity = GroupActivity.new(Phase.new('Dev'), multi_state)
        feature = Feature::FeatureId.new('feat_1')

        expect {
          activity.progress(feature, multi_state.first, State.new('Review'))
        }.to raise_error(NotWork)
      end
    end
  end
end
