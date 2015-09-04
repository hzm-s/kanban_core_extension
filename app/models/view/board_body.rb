module View
  BoardBody = Struct.new(:map) do

    def self.build(card_hashes)
      map = card_hashes.each_with_object({}) do |card_hash, map|
        feature_card = FeatureCard.new(card_hash)

        key = [feature_card.phase_name, feature_card.state_name]
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

    FeatureCard = Struct.new(:id, :feature_id_str, :phase_name, :state_name, :summary, :detail) do

      def initialize(hash)
        super(
          hash['id'],
          hash['feature_id_str'],
          hash['position_phase_name'],
          hash['position_state_name'] || '',
          hash['description_summary'],
          hash['description_detail']
        )
      end
    end
  end
end
