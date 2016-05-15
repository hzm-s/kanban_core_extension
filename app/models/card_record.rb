class CardRecord < ActiveRecord::Base
  class << self

    def with_feature(project_id_str)
      sql = <<-EOSQL
        SELECT
          card.*, feature.*
        FROM
          board_records AS board
            JOIN card_records AS card
              ON board.id = card.board_record_id
            JOIN feature_records AS feature
              ON card.feature_id = feature.feature_id
        WHERE
          board.project_id = ?
      EOSQL
      connection.select_all(sanitize_sql_array([sql, project_id_str])).to_hash
    end

    def count(project_id_str)
      sql = <<-EOSQL
        SELECT
          COUNT(*) AS count
        FROM
          board_records AS board
            JOIN card_records AS card
              ON board.id = card.board_record_id
        WHERE
          board.project_id = ?
      EOSQL
      connection.select_one(sanitize_sql_array([sql, project_id_str])).to_hash['count']
    end
  end
end
