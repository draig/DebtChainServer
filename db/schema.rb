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

ActiveRecord::Schema.define(version: 20180325084817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "contacts", force: :cascade do |t|
    t.string "internal_id"
    t.string "phones"
    t.string "name"
    t.uuid "friend_id"
    t.uuid "mapped_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sync", default: false
    t.index ["friend_id"], name: "index_contacts_on_friend_id"
    t.index ["mapped_id"], name: "index_contacts_on_mapped_id"
  end

  create_table "debts", force: :cascade do |t|
    t.string "party"
    t.string "currency"
    t.string "title"
    t.uuid "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_debts_on_creator_id"
  end

  create_table "default_avatarts", force: :cascade do |t|
    t.string "url"
  end

  create_table "payments", force: :cascade do |t|
    t.string "title"
    t.decimal "amount"
    t.string "currency"
    t.string "payer"
    t.string "participant"
    t.bigint "debt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_id"], name: "index_payments_on_debt_id"
  end

  create_table "subscribes", force: :cascade do |t|
    t.boolean "active", default: true
    t.boolean "sync", default: true
    t.uuid "user_id"
    t.bigint "debt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_id"], name: "index_subscribes_on_debt_id"
    t.index ["user_id"], name: "index_subscribes_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "ava"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
