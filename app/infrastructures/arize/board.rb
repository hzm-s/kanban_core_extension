module Arize
  module Board
    extend ActiveSupport::Concern

    included do
      self.table_name = 'board_records'

      has_many :cards, foreign_key: 'board_record_id'

      include Readers
      include Writers
    end

    module Writers

      def project_id=(project_id)
        self.project_id_str = project_id.to_s
      end
    end

    module Readers

      def project_id
        ::Project::ProjectId.new(self.project_id_str)
      end

      def card_map
        Kanban::CardMap.new(cards)
      end
    end
  end
end
