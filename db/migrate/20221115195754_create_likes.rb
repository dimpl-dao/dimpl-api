class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table(:likes, id: :uuid) do |t|
      t.references :likable, type: :uuid, polymorphic: true
      t.references :user, type: :uuid
      t.datetime :created_at, precision: 0, null: false
      t.datetime :updated_at, precision: 0, null: false
    end
  end
end
