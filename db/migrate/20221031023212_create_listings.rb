class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table(:listings) do |t|
      t.binary :hash, limit: 32
      t.index :hash
      t.virtual :hash_hex, type: :string, as: "encode(hash, 'hex')", stored: true
      t.string :title, null: false
      t.string :description, null: false
      t.numeric :price, precision: 78, scale: 0, null: false
      t.numeric :deposit, precision: 78, scale: 0, null: false
      t.numeric :bid_selected_block, precision: 39, scale: 0, null: false, default: 0
      t.numeric :remonstrable_block_interval, precision: 39, scale: 0, null: false
      t.references :user, type: :string, limit: 40, null: false, foreign_key: { to_table: :users, primary_key: :account }
      t.integer :status, limit: 1, null: false, default: 0
      t.integer :likes_count, default: 0
      t.timestamps
    end
    add_check_constraint :listings, "price > 0", name: 'listings_price_unsigned_constraint'
    add_check_constraint :listings, "deposit > 0", name: 'listings_deposit_unsigned_constraint'
  end
end
