module Arize
  module Board
    extend ActiveSupport::Concern

    included do
      self.table_name = 'board_records'
      has_many :cards

      include Readers
      include Writers
    end

    module Readers

      def project_id
        ::Project::ProjectId.new(self.project_id_str)
      end

      def stage
        @stage ||= Kanban::Stage.new(cards)
      end
    end

    module Writers

      def project_id=(project_id)
        self.project_id_str = project_id.to_s
      end
    end
  end
end
