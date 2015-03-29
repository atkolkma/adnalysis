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

ActiveRecord::Schema.define(version: 20150329144833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crunch_algorithms", force: :cascade do |t|
    t.string   "name"
    t.string   "functions"
    t.string   "type"
    t.string   "category"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "data_source_id"
    t.string   "dimensions"
    t.json     "function_settings"
  end

  create_table "data_sets", force: :cascade do |t|
    t.string   "name"
    t.string   "source_files"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.json     "stored_data",    default: {}
    t.integer  "data_source_id"
    t.string   "dimensions"
    t.string   "file_names"
  end

  create_table "data_sources", force: :cascade do |t|
    t.string "name"
    t.string "dimension_translations"
  end

  create_table "filters", force: :cascade do |t|
    t.integer "algorithm_id"
    t.integer "priority"
    t.string  "string"
    t.string  "comparison"
    t.string  "value"
  end

  create_table "groupings", force: :cascade do |t|
    t.integer "algorithm_id"
    t.integer "priority"
    t.string  "dimension1"
    t.string  "dimension2"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "name"
    t.integer  "data_set_id"
    t.integer  "crunch_algorithm_id"
    t.string   "report_preview_rows"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "sortings", force: :cascade do |t|
    t.integer "algorithm_id"
    t.integer "priority"
    t.string  "field1"
    t.string  "order1"
    t.string  "field2"
    t.string  "order2"
  end

  create_table "source_files", force: :cascade do |t|
    t.string   "remote_path"
    t.integer  "data_set_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.json     "data",        default: {}
  end

  create_table "truncates", force: :cascade do |t|
    t.integer "algorithm_id"
    t.integer "priority"
    t.integer "cutoff"
  end

end
