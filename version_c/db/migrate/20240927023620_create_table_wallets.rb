class CreateTableWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.bigint :account_id, null: false, index: { unique: true }
      t.decimal :balance, null: false, default: 0
      t.string :type, null: false
    end
  end
end
