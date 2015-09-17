class TransitionValidator < ActiveModel::EachValidator

  def validate_each(model, _, value)
    Project::Transition.from_array(value)
  rescue Project::NeedMoreThanOneState
    model.errors.add(:base, message)
  end

  private

    def message
      options[:message] || '状態は2つ以上必要です'
    end
end
