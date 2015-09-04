module View
  BoardBody = Struct.new(:map) do

    def self.build(board)
      map = board.card_records.each_with_object({}) do |card_record, map|
        phase_name = card_record.position_phase_name
        state_name = card_record.position_state_name || ''
        key = [phase_name, state_name]
        if map.key?(key)
          map[key] << card_record
        else
          map[key] = [card_record]
        end
      end
      new(map)
    end

    def cards(phase_name, state_name)
      map[[phase_name, state_name]] || []
    end

    Card = Struct.new(:state_num, :card_num) do

      def full_num
        "#{state_num}-#{card_num}"
      end

      def id
        "##{full_num}"
      end

      def summary
        "機能の概要#{full_num}"
      end
    end
  end
end
