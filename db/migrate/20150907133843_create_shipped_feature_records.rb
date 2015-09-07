class CreateShippedFeatureRecords < ActiveRecord::Migration
  def change
    create_table :shipped_feature_records do |t|
      t.references :feature_record, null: false
      t.timestamp :shipped_at, null: false
    end
  end
end
