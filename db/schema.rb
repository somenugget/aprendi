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

ActiveRecord::Schema[7.2].define(version: 2025_06_28_150212) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_deletion_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_account_deletion_requests_on_user_id"
  end

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

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "push_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent", null: false
    t.string "endpoint", null: false
    t.string "p256dh", null: false
    t.string "auth", null: false
    t.datetime "last_seen_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endpoint", "user_id"], name: "index_endpoint_user_id", unique: true
    t.index ["user_agent", "user_id"], name: "index_user_agent_user_id", unique: true
    t.index ["user_id"], name: "index_push_subscriptions_on_user_id"
  end

  create_table "streak_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "activity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_streak_logs_on_user_id"
  end

  create_table "streaks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "current_streak"
    t.integer "longest_streak"
    t.date "last_activity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_streaks_on_user_id"
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
    t.bigint "folder_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pinned", default: false
    t.index ["folder_id"], name: "index_study_sets_on_folder_id"
    t.index ["user_id"], name: "index_study_sets_on_user_id"
  end

  create_table "term_example_terms", force: :cascade do |t|
    t.bigint "term_example_id", null: false
    t.bigint "term_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_example_id"], name: "index_term_example_terms_on_term_example_id"
    t.index ["term_id"], name: "index_term_example_terms_on_term_id"
  end

  create_table "term_examples", force: :cascade do |t|
    t.string "term", null: false
    t.string "definition", null: false
    t.string "term_lang", null: false
    t.string "definition_lang", null: false
    t.string "term_example", null: false
    t.string "definition_example", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["definition"], name: "index_term_examples_on_definition"
    t.index ["definition_lang"], name: "index_term_examples_on_definition_lang"
    t.index ["term"], name: "index_term_examples_on_term"
    t.index ["term_lang"], name: "index_term_examples_on_term_lang"
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
    t.bigint "study_set_id", null: false
    t.string "term", null: false
    t.string "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_set_id"], name: "index_terms_on_study_set_id"
  end

  create_table "test_steps", force: :cascade do |t|
    t.bigint "test_id", null: false
    t.bigint "term_id", null: false
    t.integer "status", default: 0
    t.integer "exercise", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_test_steps_on_term_id"
    t.index ["test_id"], name: "index_test_steps_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tests_on_user_id"
  end

  create_table "user_auth_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.string "token_hash"
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "meta", default: {}
    t.index ["user_id"], name: "index_user_auth_tokens_on_user_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.bigint "user_id"
    t.string "tz"
    t.string "term_lang"
    t.string "definition_lang"
    t.boolean "daily_reminder", default: false
    t.boolean "weekly_reminder", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "push_notifications", default: false, null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
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
  add_foreign_key "push_subscriptions", "users"
  add_foreign_key "streak_logs", "users"
  add_foreign_key "streaks", "users"
  add_foreign_key "study_sets", "folders"
  add_foreign_key "study_sets", "users"
  add_foreign_key "term_example_terms", "term_examples"
  add_foreign_key "term_example_terms", "terms"
  add_foreign_key "term_progresses", "terms"
  add_foreign_key "term_progresses", "users"
  add_foreign_key "terms", "study_sets"
  add_foreign_key "test_steps", "terms"
  add_foreign_key "test_steps", "tests"
  add_foreign_key "tests", "users"
  add_foreign_key "user_auth_tokens", "users"
end
