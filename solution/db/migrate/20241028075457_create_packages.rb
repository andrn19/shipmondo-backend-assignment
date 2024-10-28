class CreatePackages < ActiveRecord::Migration[7.2]
  def change
    create_table :packages do |t|
      t.references :shipment, null: false, foreign_key: true
      t.string :package_number

      t.timestamps
    end
  end
end
