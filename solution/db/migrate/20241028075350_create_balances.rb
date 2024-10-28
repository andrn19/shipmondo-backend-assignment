class CreateBalances < ActiveRecord::Migration[7.2]
  def change
    create_table :balances do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :balance
      t.string :currency

      t.timestamps
    end
  end
end
