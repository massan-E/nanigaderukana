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

ActiveRecord::Schema[7.2].define(version: 2024_11_21_154704) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "letterboxes", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.bigint "program_id"
    t.index ["program_id"], name: "index_letterboxes_on_program_id"
  end

  create_table "letters", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body", null: false
    t.boolean "is_read", default: false
    t.boolean "publish", default: true
    t.bigint "letterbox_id"
    t.bigint "user_id"
    t.string "radio_name", default: "loving rabbit", null: false
    t.bigint "program_id"
    t.index ["letterbox_id"], name: "index_letters_on_letterbox_id"
    t.index ["program_id"], name: "index_letters_on_program_id"
    t.index ["user_id"], name: "index_letters_on_user_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "invitation_digest"
    t.datetime "send_invitation_at"
    t.index ["user_id"], name: "index_programs_on_user_id"
  end

  create_table "user_participations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_user_participations_on_program_id"
    t.index ["user_id", "program_id"], name: "index_user_participations_on_user_id_and_program_id", unique: true
    t.index ["user_id"], name: "index_user_participations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "letterboxes", "programs"
  add_foreign_key "letters", "letterboxes"
  add_foreign_key "letters", "programs"
  add_foreign_key "letters", "users"
  add_foreign_key "programs", "users"
  add_foreign_key "user_participations", "programs"
  add_foreign_key "user_participations", "users"
end
