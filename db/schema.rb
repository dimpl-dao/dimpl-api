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

ActiveRecord::Schema.define(version: 2022_10_31_044455) do

  create_table "listings", primary_key: "hash", id: { type: :string, limit: 64 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.decimal "price", precision: 27, scale: 18, null: false
    t.decimal "deposit", precision: 27, scale: 18, null: false
    t.string "user_id", limit: 42, null: false
    t.string "image_uri", limit: 20, null: false
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "purchase_attempt_id", limit: 64
    t.index ["hash"], name: "index_listings_on_hash"
    t.index ["purchase_attempt_id"], name: "index_listings_on_purchase_attempt_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
    t.check_constraint "egexp_like(`hash`,_utf8mb4\\'^0x[a-f0-9]{64}$\\'", name: "listing_hash_constraint"
  end

  create_table "purchase_attempts", primary_key: "hash", id: { type: :string, limit: 64 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "deposit", precision: 27, scale: 18, null: false
    t.string "user_id", limit: 42, null: false
    t.string "listing_id", limit: 64, null: false
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hash"], name: "index_purchase_attempts_on_hash"
    t.index ["listing_id"], name: "index_purchase_attempts_on_listing_id"
    t.index ["user_id"], name: "index_purchase_attempts_on_user_id"
    t.check_constraint "egexp_like(`hash`,_utf8mb4\\'^0x[a-f0-9]{64}$\\'", name: "purchase_attempt_hash_constraint"
  end

  create_table "users", primary_key: "account", id: { type: :string, limit: 42 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "nonce"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account"], name: "index_users_on_account"
    t.check_constraint "egexp_like(`account`,_utf8mb4\\'^0x[a-f0-9]{42}$\\'", name: "user_account_constraint"
  end

  add_foreign_key "listings", "purchase_attempts", primary_key: "hash"
  add_foreign_key "listings", "users", primary_key: "account"
  add_foreign_key "purchase_attempts", "listings", primary_key: "hash"
  add_foreign_key "purchase_attempts", "users", primary_key: "account"
end
