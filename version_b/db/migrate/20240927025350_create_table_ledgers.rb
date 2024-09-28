class CreateTableLedgers < ActiveRecord::Migration[7.0]
  def change
    create_table :ledgers do |t|
      t.bigint :wallet_id, null: false
      t.bigint :transaction_id, null: false, index: true
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.decimal :initial_balance, precision: 15, scale: 2, null: false
      t.decimal :updated_balance, precision: 15, scale: 2, null: false

      t.timestamps

      t.index %i[wallet_id amount]
    end
  end
end
