class CreateProposals < ActiveRecord::Migration[7.0]
  def change
    create_table(:proposals, id: :uuid) do |t|
      t.references :user, type: :uuid
      t.text :content, null: false
      t.numeric :snapshot_id, precision: 78, null: false
      t.references :listing, type: :uuid
      t.numeric :for_votes, precision: 78, null: false, default: 0
      t.numeric :against_votes, precision: 78, null: false, default: 0
      t.numeric :created_block, precision: 39, scale: 0, null: false
      t.integer :comments_count, default: 0
      t.boolean :executed, null: false, default: false
      t.timestamps
    end

    add_check_constraint :proposals, "snapshot_id >= 0", name: 'proposals_snapshot_id_unsigned_constraint'
    add_check_constraint :proposals, "created_block >= 0", name: 'proposals_created_block_unsigned_constraint'
    add_check_constraint :proposals, "for_votes >= 0", name: 'proposals_for_votes_unsigned_constraint'
    add_check_constraint :proposals, "against_votes >= 0", name: 'proposals_against_votes_unsigned_constraint'
  end
end
