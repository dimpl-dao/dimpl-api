class CreatePurchaseAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table(:purchase_attempts, id: false) do |t|
      t.string :hash, limit: 64, primary_key: true, null: false
      t.index :hash
      t.decimal :deposit, precision: 27, scale: 18, null: false
      t.references :user, type: :string, limit: 42, null: false, foreign_key: { to_table: :users, primary_key: :account }
      t.references :listing, type: :string, limit: 64, null: false, foreign_key: { to_table: :listings, primary_key: :hash }
      t.integer :status, limit: 1, null: false, default: 0
      t.timestamps
    end
    add_check_constraint :purchase_attempts, "hash RLIKE '^0x[a-f0-9]{64}$'", name: 'purchase_attempt_hash_constraint'
    add_reference :listings, :purchase_attempt, type: :string, limit: 64, foreign_key: { to_table: :purchase_attempts, primary_key: :hash }
  end
end
