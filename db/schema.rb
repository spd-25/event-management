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

ActiveRecord::Schema.define(version: 20160822235211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "category_id"
    t.index ["category_id"], name: "index_categories_on_category_id", using: :btree
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

  create_table "categories_seminars", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "seminar_id",  null: false
    t.index ["category_id"], name: "index_categories_seminars_on_category_id", using: :btree
    t.index ["seminar_id"], name: "index_categories_seminars_on_seminar_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "seminar_id"
    t.date     "date"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "location_id"
    t.string   "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["location_id"], name: "index_events_on_location_id", using: :btree
    t.index ["seminar_id"], name: "index_events_on_seminar_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.jsonb    "address",     default: "{}"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "seminars", force: :cascade do |t|
    t.string   "number",                       null: false
    t.string   "title",                        null: false
    t.string   "subtitle"
    t.integer  "year",                         null: false
    t.text     "benefit"
    t.text     "content"
    t.text     "notes"
    t.text     "due_date"
    t.text     "price_text"
    t.text     "date_text"
    t.text     "location_text"
    t.string   "time"
    t.integer  "max_attendees"
    t.jsonb    "others",        default: "{}"
    t.integer  "location_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["location_id"], name: "index_seminars_on_location_id", using: :btree
  end

  create_table "seminars_teachers", id: false, force: :cascade do |t|
    t.integer "seminar_id", null: false
    t.integer "teacher_id", null: false
    t.index ["seminar_id"], name: "index_seminars_teachers_on_seminar_id", using: :btree
    t.index ["teacher_id"], name: "index_seminars_teachers_on_teacher_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "profession"
    t.jsonb    "address",    default: "{}"
    t.jsonb    "contact",    default: "{}"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "role"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "categories", "categories", on_delete: :cascade
  add_foreign_key "categories_seminars", "categories", on_delete: :cascade
  add_foreign_key "categories_seminars", "seminars", on_delete: :cascade
  add_foreign_key "events", "locations"
  add_foreign_key "events", "seminars", on_delete: :cascade
  add_foreign_key "seminars", "locations"
  add_foreign_key "seminars_teachers", "seminars", on_delete: :cascade
  add_foreign_key "seminars_teachers", "teachers", on_delete: :cascade
end
