class CreateStageRecords < ActiveRecord::Migration
  def change
    create_table :stage_records do |t|
      t.references :board, null: false
      t.string :phase_description, null: false
      t.integer :wip_limit_count
    end
  end
end
