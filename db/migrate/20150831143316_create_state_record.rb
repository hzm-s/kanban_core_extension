class CreateStateRecord < ActiveRecord::Migration
  def change
    create_table :state_records do |t|
      t.references :project, null: false
      t.string :phase_name, null: false
      t.integer :order, null: false
      t.string :state_name, null: false
    end

    add_index :state_records, [:project_id, :phase_name, :order]
  end
end
