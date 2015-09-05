module View
  FeatureCard = Struct.new(:project_id_str, :id, :feature_id_str, :position_phase_name, :position_state_name, :summary, :detail) do

    def initialize(project_id_str, hash)
      super(
        project_id_str,
        hash['id'],
        hash['feature_id_str'],
        hash['position_phase_name'],
        hash['position_state_name'] || '',
        hash['description_summary'],
        hash['description_detail']
      )
    end

    def forward_card_command
      ForwardCardCommand.new(
        project_id_str: project_id_str,
        feature_id_str: feature_id_str,
        position_phase_name: position_phase_name,
        position_state_name: position_state_name
      )
    end
  end
end
