class CreateBackloggedFeatureRecords < ActiveRecord::Migration
  def change
    create_table :backlogged_feature_records do |t|
      t.references :feature_record, null: false
      t.timestamp :backlogged_at, null: false
    end
  end
end
