class CreateFeatureRecords < ActiveRecord::Migration
  def change
    create_table :feature_records do |t|
      t.string :project_id_str, null: false
      t.string :feature_id_str, null: false
      t.string :description_summary, null: false
      t.text :description_detail
    end
  end
end
