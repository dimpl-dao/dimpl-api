class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table(:users, id: :uuid) do |t|
      t.string :klaytn_address, limit: 40, unique: true
      t.index :klaytn_address
      t.string :username
      t.timestamps 
    end
  end
end
