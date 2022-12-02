class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table(:votes, id: :uuid) do |t|
      t.references :proposal, type: :uuid
      t.integer :vote_type, limit: 1, null: false
      t.references :user, type: :uuid
      t.datetime :created_at, precision: 0, null: false
      t.datetime :updated_at, precision: 0, null: false
    end
    add_check_constraint :votes, "vote_type >= 0 and vote_type <=1", name: 'votes_vote_type_constraint'
  end
end
