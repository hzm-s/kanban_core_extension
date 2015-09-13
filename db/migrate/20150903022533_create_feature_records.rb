class CreateFeatureRecords < ActiveRecord::Migration
  def change
    create_table :feature_records do |t|
      t.string :project_id_str, null: false
      t.string :feature_id_str, null: false
      t.integer :number_value, null: false
      t.string :description_summary, null: false
      t.text :description_detail
    end

    add_index :feature_records, [:project_id_str, :number_value], unique: true
  end
end
