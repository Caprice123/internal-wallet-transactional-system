source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.0.8", ">= 7.0.8.1"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem "bootsnap", require: false
gem "lograge"
gem "httpparty"
gem 'dotenv'

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "listen"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen"

  gem "rubocop"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"

  gem "parallel_tests"
  gem "rspec"
  gem "rspec-rails"
  gem "rspec-retry"
end
