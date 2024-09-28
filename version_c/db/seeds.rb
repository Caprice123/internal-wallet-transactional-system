# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
class Seeder
  class << self
    def execute_all
      # safeguard the seeds from being ran in prod
      return unless Rails.env.development?

      # add user
      seed_mock_accounts
    end

    private def seed_mock_accounts
      3.times do |i|        
        user_account = UserAccount.create!(
          name: "user account #{i}",
          email: "useraccount#{i}@gmail.com",
          password: "password",
        )
        Wallet.create!(account: user_account)

        team_account = TeamAccount.create!(
          name: "team account #{i}",
          email: "teamaccount#{i}@gmail.com",
          password: "password",
        )
        Wallet.create!(account: team_account)

        stock_account = StockAccount.create!(
          name: "stock account #{i}",
          email: "stockaccount#{i}@gmail.com",
          password: "password",
        )
        Wallet.create!(account: stock_account)
      end
    end
  end
end

Seeder.execute_all
