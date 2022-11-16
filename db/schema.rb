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

ActiveRecord::Schema[7.0].define(version: 2022_11_16_054359) do
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

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.string "commentable_type"
    t.uuid "commentable_id"
    t.integer "comments_count", default: 0
    t.integer "likes_count", default: 0
    t.string "user_id", limit: 40, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "likable_type"
    t.uuid "likable_id"
    t.string "user_id", limit: 40, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.binary "hash"
    t.virtual "hash_hex", type: :string, as: "encode(hash, 'hex'::text)", stored: true
    t.string "title", null: false
    t.string "description", null: false
    t.decimal "price", precision: 78, null: false
    t.decimal "deposit", precision: 78, null: false
    t.decimal "bid_selected_block", precision: 39, default: "0", null: false
    t.decimal "remonstrable_block_interval", precision: 39, null: false
    t.string "user_id", limit: 40, null: false
    t.integer "status", limit: 2, default: 0, null: false
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "purchase_attempt_id"
    t.index ["hash"], name: "index_listings_on_hash"
    t.index ["purchase_attempt_id"], name: "index_listings_on_purchase_attempt_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
    t.check_constraint "deposit > 0::numeric", name: "listings_deposit_unsigned_constraint"
    t.check_constraint "price > 0::numeric", name: "listings_price_unsigned_constraint"
  end

  create_table "proposals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_id", limit: 40, null: false
    t.text "content", null: false
    t.decimal "snapshot_id", precision: 78, null: false
    t.uuid "listing_id"
    t.decimal "for_votes", precision: 78, default: "0", null: false
    t.decimal "against_votes", precision: 78, default: "0", null: false
    t.decimal "created_block", precision: 39, null: false
    t.integer "comments_count", default: 0
    t.boolean "executed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_proposals_on_listing_id"
    t.index ["user_id"], name: "index_proposals_on_user_id"
    t.check_constraint "against_votes >= 0::numeric", name: "proposals_against_votes_unsigned_constraint"
    t.check_constraint "created_block >= 0::numeric", name: "proposals_created_block_unsigned_constraint"
    t.check_constraint "for_votes >= 0::numeric", name: "proposals_for_votes_unsigned_constraint"
    t.check_constraint "snapshot_id >= 0::numeric", name: "proposals_snapshot_id_unsigned_constraint"
  end

  create_table "purchase_attempts", force: :cascade do |t|
    t.binary "hash", null: false
    t.virtual "hash_hex", type: :string, as: "encode(hash, 'hex'::text)", stored: true
    t.decimal "deposit", precision: 78, null: false
    t.decimal "created_block", precision: 39, null: false
    t.string "user_id", limit: 40, null: false
    t.bigint "listing_id"
    t.integer "status", limit: 2, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash"], name: "index_purchase_attempts_on_hash"
    t.index ["listing_id"], name: "index_purchase_attempts_on_listing_id"
    t.index ["user_id"], name: "index_purchase_attempts_on_user_id"
    t.check_constraint "created_block >= 0::numeric", name: "purchase_attempts_created_block_unsigned_constraint"
    t.check_constraint "deposit > 0::numeric", name: "purchase_attempts_deposit_unsigned_constraint"
  end

  create_table "rebuttals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_id", limit: 40, null: false
    t.text "content", null: false
    t.uuid "proposal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_rebuttals_on_proposal_id"
    t.index ["user_id"], name: "index_rebuttals_on_user_id"
  end

  create_table "users", primary_key: "account", id: { type: :string, limit: 40 }, force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account"], name: "index_users_on_account"
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "proposal_id"
    t.integer "vote_type", limit: 2, null: false
    t.string "user_id", limit: 40, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_votes_on_proposal_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.check_constraint "vote_type >= 0 AND vote_type <= 1", name: "votes_vote_type_constraint"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users", primary_key: "account"
  add_foreign_key "likes", "users", primary_key: "account"
  add_foreign_key "listings", "users", primary_key: "account"
  add_foreign_key "proposals", "users", primary_key: "account"
  add_foreign_key "purchase_attempts", "users", primary_key: "account"
  add_foreign_key "rebuttals", "users", primary_key: "account"
  add_foreign_key "votes", "users", primary_key: "account"
end
