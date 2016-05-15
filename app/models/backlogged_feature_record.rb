class BackloggedFeatureRecord < ActiveRecord::Base
  class << self

    def with_project(project_id_str)
      sql = <<-EOSQL
        SELECT
          feature.*
        FROM
          feature_records AS feature
            JOIN backlogged_feature_records AS backlogged
              ON feature.id = backlogged.feature_record_id
            LEFT OUTER JOIN card_records AS card
              ON feature.feature_id = card.feature_id
            LEFT OUTER JOIN shipped_feature_records AS shipped
              ON feature.id = shipped.feature_record_id
        WHERE
          feature.project_id = ?
            AND backlogged.id IS NOT NULL
            AND card.id IS NULL
            AND shipped.id IS NULL
        ORDER BY feature.id
      EOSQL
      connection.select_all(sanitize_sql_array([sql, project_id_str])).to_hash
    end

    def count(project_id_str)
      with_project(project_id_str).size
    end
  end
end
