class CreateStateRecord < ActiveRecord::Migration
  def change
    create_table :state_records do |t|
      t.references :project, null: false
      t.string :phase_name, null: false
      t.integer :order, null: false
      t.string :state_description, null: false
    end
  end
end
