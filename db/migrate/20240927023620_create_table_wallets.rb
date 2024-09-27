class CreateTableWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.bigint :user_id, null: false, index: { unique: true }
      t.bigint :current_balance, null: false, default: 0

      t.timestamps
    end
  end
end
