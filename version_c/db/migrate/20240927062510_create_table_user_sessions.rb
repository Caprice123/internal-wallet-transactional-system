class CreateTableUserSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_sessions do |t|
      t.bigint :user_id, null: false
      t.string :session_id, null: false, index: { unique: true }
      t.datetime :expired_at, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps

      t.index %i[user_id enabled]
    end
  end
end
