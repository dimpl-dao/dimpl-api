class CreateDeliveryAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table(:delivery_addresses, id: :uuid) do |t|
      t.string :address_ko
      t.string :address_en
      t.string :zonecode, null: false
      t.string :specifics
      t.string :name
      t.boolean :main, null: false, default: false
      t.references :user, type: :uuid
      t.datetime :created_at, precision: 0, null: false
    end
    add_reference :bids, :delivery_address, type: :uuid
  end
end
