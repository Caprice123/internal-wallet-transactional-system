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
      seed_mock_users
    end

    private def seed_mock_users
      3.times do |i|        
        user = User.create!(
          name: "user #{i}",
          email: "user#{i}@gmail.com",
          password: "password",
        )
        UserWallet.create!(user: user)
        TeamWallet.create!(user: user)
        StockWallet.create!(user: user)
      end
    end
  end
end

Seeder.execute_all
