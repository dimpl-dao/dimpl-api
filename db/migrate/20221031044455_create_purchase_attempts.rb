class CreatePurchaseAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table(:purchase_attempts) do |t|
      t.binary :hash, limit: 32, null: false
      t.index :hash
      t.virtual :hash_hex, type: :string, as: "encode(hash, 'hex')", stored: true
      t.numeric :deposit, precision: 78, null: false
      t.numeric :created_block, precision: 39, scale: 0, null: false
      t.references :user, type: :string, limit: 40, null: false, foreign_key: { to_table: :users, primary_key: :account }
      t.references :listing
      t.integer :status, limit: 1, null: false, default: 0
      t.timestamps
    end
    add_reference :listings, :purchase_attempt
    add_check_constraint :purchase_attempts, "deposit > 0", name: 'purchase_attempts_deposit_unsigned_constraint'
    add_check_constraint :purchase_attempts, "created_block >= 0", name: 'purchase_attempts_created_block_unsigned_constraint'
  end
end
