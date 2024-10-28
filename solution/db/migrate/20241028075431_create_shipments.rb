class CreateShipments < ActiveRecord::Migration[7.2]
  def change
    create_table :shipments do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :shipment_id

      t.timestamps
    end
  end
end
