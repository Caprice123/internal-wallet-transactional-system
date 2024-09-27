class CreateTableAccountSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :account_sessions do |t|
      t.bigint :account_id, null: false
      t.string :session_id, null: false, index: true
      t.datetime :expired_at, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps

      t.index %i[account_id enabled]
    end
  end
end
