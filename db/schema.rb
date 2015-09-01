# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150901133932) do

  create_table "board_records", force: :cascade do |t|
    t.string "project_id_str", null: false
  end

  create_table "card_records", force: :cascade do |t|
    t.integer "board_id",       null: false
    t.string  "feature_id_str", null: false
    t.string  "position_phase", null: false
    t.string  "position_state", null: false
  end

  create_table "phase_spec_records", force: :cascade do |t|
    t.integer "project_id",        null: false
    t.integer "order",             null: false
    t.string  "phase_description", null: false
    t.integer "wip_limit_count"
  end

  create_table "project_records", force: :cascade do |t|
    t.string "project_id_str",   null: false
    t.string "description_name", null: false
    t.text   "description_goal", null: false
  end

  create_table "state_records", force: :cascade do |t|
    t.integer "project_id",        null: false
    t.string  "phase_description", null: false
    t.integer "order",             null: false
    t.string  "state_description", null: false
  end

end
