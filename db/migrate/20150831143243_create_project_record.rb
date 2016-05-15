class CreateProjectRecord < ActiveRecord::Migration
  def change
    create_table :project_records do |t|
      t.string :project_id, null: false
      t.string :description_name, null: false
      t.text :description_goal, null: false
    end

    add_index :project_records, :project_id, unique: true
  end
end
