class CardRecord < ActiveRecord::Base

  def self.with_feature(project_id_str)
    sql = <<-EOSQL
      SELECT
        card.*, feature.*
      FROM
        board_records AS board
          JOIN card_records AS card
            ON board.id = card.board_record_id
          JOIN feature_records AS feature
            ON card.feature_id_str = feature.feature_id_str
      WHERE
        board.project_id_str = ?
    EOSQL
    connection.select_all(sanitize_sql_array([sql, project_id_str])).to_hash
  end
end
