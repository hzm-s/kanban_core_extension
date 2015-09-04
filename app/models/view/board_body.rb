module View
  module BoardBody

    def self.build
      stages = 1.upto(7).map {|n| Stage.build(n) }
      StageList.new(stages)
    end

    StageList = Struct.new(:stages) do

      def stage_size
        stages.size
      end
    end

    Stage = Struct.new(:cards) do

      def self.build(n)
        card_size = (1..5).to_a.sample
        cards = 1.upto(card_size).map {|m| Card.new(n, m) }
        new(cards)
      end
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
