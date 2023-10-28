# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_10_28_015952) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "token"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "folders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "study_configs", force: :cascade do |t|
    t.string "configurable_type", null: false
    t.bigint "configurable_id", null: false
    t.string "term_lang"
    t.string "definition_lang"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["configurable_type", "configurable_id"], name: "index_study_configs_on_configurable"
  end

  create_table "study_sets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "folder_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_study_sets_on_folder_id"
    t.index ["user_id"], name: "index_study_sets_on_user_id"
  end

  create_table "term_progresses", force: :cascade do |t|
    t.bigint "term_id", null: false
    t.bigint "user_id", null: false
    t.boolean "learnt", default: false
    t.integer "tests_count", default: 0
    t.integer "success_percentage"
    t.datetime "next_test_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_term_progresses_on_term_id"
    t.index ["user_id"], name: "index_term_progresses_on_user_id"
  end

  create_table "terms", force: :cascade do |t|
    t.bigint "folder_id", null: false
    t.bigint "study_set_id", null: false
    t.string "term", null: false
    t.string "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_terms_on_folder_id"
    t.index ["study_set_id"], name: "index_terms_on_study_set_id"
  end

  create_table "test_steps", force: :cascade do |t|
    t.bigint "test_id", null: false
    t.bigint "term_id", null: false
    t.integer "status", default: 0
    t.integer "type", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_test_steps_on_term_id"
    t.index ["test_id"], name: "index_test_steps_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.bigint "study_set_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_set_id"], name: "index_tests_on_study_set_id"
    t.index ["user_id"], name: "index_tests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "timezone"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authorizations", "users"
  add_foreign_key "folders", "users"
  add_foreign_key "study_sets", "folders"
  add_foreign_key "study_sets", "users"
  add_foreign_key "term_progresses", "terms"
  add_foreign_key "term_progresses", "users"
  add_foreign_key "terms", "folders"
  add_foreign_key "terms", "study_sets"
  add_foreign_key "test_steps", "terms"
  add_foreign_key "test_steps", "tests"
  add_foreign_key "tests", "study_sets"
  add_foreign_key "tests", "users"
end
