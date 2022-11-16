class CreateRebuttals < ActiveRecord::Migration[7.0]
  def change
    create_table(:rebuttals, id: :uuid) do |t|
      t.references :user, type: :string, limit: 40, null: false, foreign_key: { to_table: :users, primary_key: :account }
      t.text :content, null: false
      t.references :proposal, type: :uuid
      t.timestamps
    end
  end
end
