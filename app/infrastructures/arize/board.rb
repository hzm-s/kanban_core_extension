module Arize
  module Board
    extend ActiveSupport::Concern

    included do
      self.table_name = 'board_records'
      has_many :stage_records

      include BoardPersister
      include BoardBuilder
    end

    module BoardPersister
    end

    module BoardBuilder
    end
  end
end
