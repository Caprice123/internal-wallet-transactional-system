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

      # add account
      seed_mock_accounts
    end

    private def seed_mock_accounts
      3.times do |i|        
        account = Account.create!(
          name: "account #{i}",
          email: "account#{i}@gmail.com",
          password: "password",
        )
        UserWallet.create!(account: account)
        TeamWallet.create!(account: account)
        StockWallet.create!(account: account)
      end
    end
  end
end

Seeder.execute_all
