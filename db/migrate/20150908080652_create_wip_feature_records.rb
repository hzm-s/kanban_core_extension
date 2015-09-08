class CreateWipFeatureRecords < ActiveRecord::Migration
  def change
    create_table :wip_feature_records do |t|
      t.references :feature_record, null: false
      t.timestamp :started_at, null: false
    end
  end
end
