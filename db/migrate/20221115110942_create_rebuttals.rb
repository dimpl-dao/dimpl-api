class CreateRebuttals < ActiveRecord::Migration[7.0]
  def change
    create_table(:rebuttals, id: :uuid) do |t|
      t.references :user, type: :uuid
      t.text :content, null: false
      t.references :proposal, type: :uuid
      t.datetime :created_at, precision: 0, null: false
      t.datetime :updated_at, precision: 0, null: false
    end
  end
end
