class CreateBids < ActiveRecord::Migration[7.0]
  def change
    create_table(:bids, id: :uuid) do |t|
      t.numeric :hash_id, precision: 78, scale: 0, unique: true
      t.numeric :deposit, precision: 78, null: false
      t.numeric :created_block, precision: 39, scale: 0, null: false
      t.references :user, type: :uuid
      t.references :listing
      t.integer :status, limit: 1, null: false, default: 0
      t.timestamps
    end
    add_reference :listings, :bid, type: :uuid
    add_check_constraint :bids, "deposit >= 0", name: 'bids_deposit_unsigned_constraint'
    add_check_constraint :bids, "created_block >= 0", name: 'bids_created_block_unsigned_constraint'
  end
end
