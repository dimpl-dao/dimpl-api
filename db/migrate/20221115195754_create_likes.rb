class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table(:likes, id: :uuid) do |t|
      t.references :likable, type: :uuid, polymorphic: true
      t.references :user, type: :string, limit: 40, null: false, foreign_key: { to_table: :users, primary_key: :account }
      t.timestamps
    end
  end
end
