module View
  BoardBody = Struct.new(:map) do

    def self.build(project_id_str, card_hashes)
      map = card_hashes.each_with_object({}) do |card_hash, map|
        feature_card = FeatureCard.new(project_id_str, card_hash)

        key = [feature_card.step_phase_name, feature_card.step_state_name]
        if map.key?(key)
          map[key] << feature_card
        else
          map[key] = [feature_card]
        end
      end

      new(map)
    end

    def cards(phase_name, state_name)
      map[[phase_name, state_name]] || []
    end
  end
end
