class CreateBoardRecords < ActiveRecord::Migration
  def change
    create_table :board_records do |t|
      t.string :project_id_str, null: false
    end

    add_index :board_records, :project_id_str, unique: true
  end
end
