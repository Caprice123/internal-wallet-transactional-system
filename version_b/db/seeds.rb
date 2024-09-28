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
    end
  end
end

Seeder.execute_all
