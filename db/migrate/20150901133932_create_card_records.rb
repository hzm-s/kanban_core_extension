class CreateCardRecords < ActiveRecord::Migration
  def change
    create_table :card_records do |t|
      t.references :board_record, null: false
      t.string :feature_id, null: false
      t.string :step_phase_name, null: false
      t.string :step_state_name
    end

    add_index :card_records, :feature_id, unique: true
  end
end
