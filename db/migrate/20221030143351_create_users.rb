class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table(:users, id: false) do |t|
      t.string :account, limit: 40, primary_key: true
      t.index :account
      t.string :username
      t.timestamps 
    end
  end
end
