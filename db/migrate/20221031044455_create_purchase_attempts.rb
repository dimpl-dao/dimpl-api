class CreatePurchaseAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table(:purchase_attempts, id: :uuid) do |t|
      t.numeric :hash, precision: 78, scale: 0, unique: true
      t.numeric :deposit, precision: 78, null: false
      t.numeric :created_block, precision: 39, scale: 0, null: false
      t.references :user, type: :uuid
      t.references :listing
      t.integer :status, limit: 1, null: false, default: 0
      t.timestamps
    end
    add_reference :listings, :purchase_attempt, typ: :uuid
    add_check_constraint :purchase_attempts, "deposit > 0", name: 'purchase_attempts_deposit_unsigned_constraint'
    add_check_constraint :purchase_attempts, "created_block >= 0", name: 'purchase_attempts_created_block_unsigned_constraint'
  end
end
