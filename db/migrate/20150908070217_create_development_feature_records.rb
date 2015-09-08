class CreateDevelopmentFeatureRecords < ActiveRecord::Migration
  def change
    create_table :development_feature_records do |t|
      t.references :feature_record, null: false
      t.timestamp :start_at, null: false
    end
  end
end
