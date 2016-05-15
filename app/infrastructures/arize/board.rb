module Arize
  module Board
    extend ActiveSupport::Concern

    included do
      self.table_name = 'board_records'

      has_many :cards, foreign_key: 'board_record_id'

      attribute :project_id, :project_id

      include Readers
    end

    module Readers

      def card_map
        Kanban::CardMap.new(cards)
      end
    end
  end
end
