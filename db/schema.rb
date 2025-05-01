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

ActiveRecord::Schema[8.0].define(version: 2025_05_01_211651) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clinics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "status"
    t.string "website"
  end

  create_table "exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.string "video_url"
    t.text "objective"
  end

  create_table "patients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "clinic_id", null: false
    t.datetime "agree_terms_at"
    t.datetime "agree_privacy_at"
    t.string "status"
    t.text "diagnosis"
    t.text "treatment"
    t.index ["clinic_id"], name: "index_patients_on_clinic_id"
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "routine_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "routine_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "order", default: 0
    t.integer "series"
    t.integer "repetitions"
    t.integer "accuracy_score"
    t.string "difficulty"
    t.integer "rest_time"
    t.text "feedback"
    t.text "notes"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.index ["exercise_id"], name: "index_routine_exercises_on_exercise_id"
    t.index ["routine_id"], name: "index_routine_exercises_on_routine_id"
  end

  create_table "routines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "status"
    t.decimal "accuracy_score", precision: 19, scale: 4, default: "0.0", null: false
    t.index ["patient_id"], name: "index_routines_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "clinic_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "role"
    t.datetime "inactivated_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "gender"
    t.string "phone"
    t.index ["clinic_id"], name: "index_users_on_clinic_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "patients", "clinics"
  add_foreign_key "patients", "users"
  add_foreign_key "routine_exercises", "exercises"
  add_foreign_key "routine_exercises", "routines"
  add_foreign_key "routines", "patients"
  add_foreign_key "users", "clinics"
end
