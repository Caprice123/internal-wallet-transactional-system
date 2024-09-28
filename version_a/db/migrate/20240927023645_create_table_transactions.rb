class CreateTableTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :source_wallet_id
      t.bigint :target_wallet_id
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :type, null: false

      t.timestamps

      t.index %i[source_wallet_id type]
      t.index %i[target_wallet_id type]
      t.index %i[type]
    end
  end
end
