class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:users, id: false) do |t|
      t.string :account, limit: 42, primary_key: true, null: false
      t.index :account
      t.string :username
      t.string :profile_uri
      t.string :background_uri
      t.string :nonce
      t.timestamps 
    end
    add_check_constraint :users, "account RLIKE '^0x[a-f0-9]{42}$'", name: 'user_account_constraint'
  end
end
