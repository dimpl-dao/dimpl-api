class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table(:listings, id: false) do |t|
      t.string :hash, limit: 64, primary_key: true, null: false
      t.index :hash
      t.string :title, null: false
      t.string :description, null: false
      t.decimal :price, precision: 27, scale: 18, null: false
      t.decimal :deposit, precision: 27, scale: 18, null: false
      t.references :user, type: :string, limit: 42, null: false, foreign_key: { to_table: :users, primary_key: :account }
      t.string :image_uri, limit: 20, null: false
      t.integer :status, limit: 1, null: false, default: 0
      t.timestamps
    end
    add_check_constraint :listings, "hash RLIKE '^0x[a-f0-9]{64}$'", name: 'listing_hash_constraint'
  end
end
