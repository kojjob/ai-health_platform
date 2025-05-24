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

ActiveRecord::Schema[8.0].define(version: 2025_05_22_213821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.text "first_name_ciphertext"
    t.text "last_name_ciphertext"
    t.text "phone_number_ciphertext"
    t.boolean "two_factor_enabled", default: false
    t.text "two_factor_secret_ciphertext"
    t.integer "status", default: 0
    t.datetime "last_activity_at"
    t.text "date_of_birth_ciphertext"
    t.text "blood_type_ciphertext"
    t.text "allergies_ciphertext"
    t.text "medical_conditions_ciphertext"
    t.text "medications_ciphertext"
    t.text "emergency_contact_ciphertext"
    t.text "medical_license_number_ciphertext"
    t.string "specialization"
    t.integer "years_of_experience"
    t.boolean "accepting_new_patients", default: true
    t.string "timezone"
    t.text "practice_location_ciphertext"
    t.boolean "available_for_emergency", default: false
    t.boolean "identity_verified", default: false
    t.datetime "last_background_check_at"
    t.integer "hipaa_compliance_status", default: 0
    t.index ["accepting_new_patients"], name: "index_users_on_accepting_new_patients"
    t.index ["available_for_emergency"], name: "index_users_on_available_for_emergency"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["hipaa_compliance_status"], name: "index_users_on_hipaa_compliance_status"
    t.index ["identity_verified"], name: "index_users_on_identity_verified"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["specialization"], name: "index_users_on_specialization"
    t.index ["status"], name: "index_users_on_status"
    t.index ["timezone"], name: "index_users_on_timezone"
    t.index ["two_factor_enabled"], name: "index_users_on_two_factor_enabled"
    t.index ["type"], name: "index_users_on_type"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end
end
