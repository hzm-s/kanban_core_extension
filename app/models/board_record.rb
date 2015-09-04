class BoardRecord < ActiveRecord::Base
  has_many :card_records

  class << self

    def with_cards(project_id_str)
      joins(:card_records)
        .find_by(project_id_str)
    end
  end
end
