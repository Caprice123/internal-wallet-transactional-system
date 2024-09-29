# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_09_27_062510) do
  create_table "account_sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "session_id", null: false
    t.datetime "expired_at", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "enabled"], name: "index_account_sessions_on_account_id_and_enabled"
    t.index ["session_id"], name: "index_account_sessions_on_session_id", unique: true
  end

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "ledgers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.bigint "transaction_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.decimal "initial_balance", precision: 15, scale: 2, null: false
    t.decimal "updated_balance", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_ledgers_on_transaction_id"
    t.index ["wallet_id", "amount"], name: "index_ledgers_on_wallet_id_and_amount"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "source_wallet_id"
    t.bigint "target_wallet_id"
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_wallet_id", "type"], name: "index_transactions_on_source_wallet_id_and_type"
    t.index ["target_wallet_id", "type"], name: "index_transactions_on_target_wallet_id_and_type"
    t.index ["type"], name: "index_transactions_on_type"
  end

  create_table "wallets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "balance", precision: 10, default: "0", null: false
    t.string "type", null: false
    t.index ["account_id"], name: "index_wallets_on_account_id", unique: true
  end

end
