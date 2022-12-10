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

ActiveRecord::Schema[7.0].define(version: 2022_12_01_151851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bids", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "hash_id", precision: 78
    t.decimal "deposit", precision: 78, null: false
    t.decimal "created_block", precision: 39
    t.uuid "user_id"
    t.uuid "listing_id"
    t.string "description"
    t.integer "status", limit: 2, default: 0, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.uuid "delivery_address_id"
    t.index ["delivery_address_id"], name: "index_bids_on_delivery_address_id"
    t.index ["hash_id"], name: "index_bids_on_hash_id", unique: true
    t.index ["listing_id"], name: "index_bids_on_listing_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
    t.check_constraint "created_block >= 0::numeric", name: "bids_created_block_unsigned_constraint"
    t.check_constraint "deposit >= 0::numeric", name: "bids_deposit_unsigned_constraint"
  end

  create_table "delivery_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address_ko"
    t.string "address_en"
    t.string "zonecode", null: false
    t.string "specifics"
    t.string "name"
    t.boolean "main", default: false, null: false
    t.uuid "user_id"
    t.datetime "created_at", precision: 0, null: false
    t.index ["user_id"], name: "index_delivery_addresses_on_user_id"
  end

  create_table "listings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "hash_id", precision: 78
    t.string "title"
    t.string "description"
    t.decimal "price", precision: 78, null: false
    t.decimal "deposit", precision: 78, null: false
    t.decimal "bid_selected_block", precision: 39, default: "0", null: false
    t.decimal "remonstrable_block_interval", precision: 39, null: false
    t.uuid "user_id"
    t.integer "status", limit: 2, default: 0, null: false
    t.integer "likes_count", default: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.uuid "bid_id"
    t.index ["bid_id"], name: "index_listings_on_bid_id"
    t.index ["hash_id"], name: "index_listings_on_hash_id", unique: true
    t.index ["user_id"], name: "index_listings_on_user_id"
    t.check_constraint "deposit >= 0::numeric", name: "listings_deposit_unsigned_constraint"
    t.check_constraint "price >= 0::numeric", name: "listings_price_unsigned_constraint"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "klaytn_address", limit: 40
    t.string "username"
    t.string "image_uri"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["klaytn_address"], name: "index_users_on_klaytn_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
