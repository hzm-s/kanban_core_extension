class CreatePhaseSpecRecord < ActiveRecord::Migration
  def change
    create_table :phase_spec_records do |t|
      t.references :project, null: false
      t.integer :order, null: false
      t.string :phase_description, null: false
      t.integer :wip_limit_count
    end
  end
end
