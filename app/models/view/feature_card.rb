module View
  FeatureCard = Struct.new(:project_id_str, :feature_number, :feature_id_str, :step_phase_name, :step_state_name, :summary, :detail) do

    def initialize(project_id_str, hash)
      super(
        project_id_str,
        hash['number'],
        hash['feature_id_str'],
        hash['step_phase_name'],
        hash['step_state_name'] || '',
        hash['description_summary'],
        hash['description_detail']
      )
    end

    def forward_card_command
      ForwardCardCommand.new(
        project_id_str: project_id_str,
        feature_id_str: feature_id_str,
        step_phase_name: step_phase_name,
        step_state_name: step_state_name
      )
    end
  end
end
