class CreateFeatureRecords < ActiveRecord::Migration
  def change
    create_table :feature_records do |t|
      t.string :project_id, null: false
      t.string :feature_id, null: false
      t.integer :number, null: false
      t.string :description_summary, null: false
      t.text :description_detail
    end

    add_index :feature_records, :feature_id, unique: true
    add_index :feature_records, [:project_id, :number], unique: true
  end
end
