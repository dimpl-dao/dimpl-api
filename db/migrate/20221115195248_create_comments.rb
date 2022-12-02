class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table(:comments, id: :uuid) do |t|
      t.text :content
      t.references :commentable, type: :uuid, polymorphic: true
      t.integer :comments_count, default: 0
      t.integer :likes_count, default: 0
      t.references :user, type: :uuid
      t.datetime :created_at, precision: 0, null: false
      t.datetime :updated_at, precision: 0, null: false
    end
  end
end
