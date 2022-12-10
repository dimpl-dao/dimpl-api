class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table(:users, id: :uuid) do |t|
      t.string :klaytn_address, limit: 40
      t.index :klaytn_address, unique: true
      t.string :username
      t.string :image_uri
      t.datetime :created_at, precision: 0, null: false
      t.datetime :updated_at, precision: 0, null: false
    end
  end
end
