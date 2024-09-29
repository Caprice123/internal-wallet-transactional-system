# Internal Wallet Transactional System API (Version A)

This project implements an internal wallet transactional system that handles deposits and withdrawals from our current wallet and transfer to other peoples wallet. It also includes custom authentication for managing sessions and a library for retrieving stock prices.

## Pre-requisites
- Ruby 3.3.0
- Mysql 8.3.0
- Bundler 2.5.7 and Rails 7.0.8.4

## How to start the server?
1. Install all current dependencies
    ```
    gem install bundler -v 2.5.7
    bundle install
    ```

2. Run this command to create the database, migrate the database and seed the database
    ```
    rails db:create db:migrate db:seed
    ```

3. Run server
    ```
    rails s
    ```

## How to run test?

1. Run this command to migrate the database for the test environment
    ```
    RAILS_ENV=test rails db:migrate
    ```

2. Start the spring test
    ```
    spring rspec <path-to-test-file>
    ```

## Configuration: Environment Secrets

This application requires various environment variables for connecting to external services and databases. These variables are defined in a secret configuration file and injected via environment variables.

The file is structured in different environments, including `development`, `test`, and `production`, each inheriting from a common base.

### Required Environment Variables

Ensure the following environment variables are set:

| Environment Variable   | Description                                        | Default (Development) | Default (Test) | Options         |
|------------------------|----------------------------------------------------|-----------------------|----------------|-----------------|
| `DB_HOST`              | The host of your database server.                  | `127.0.0.1`           | `127.0.0.1`    |                 |
| `DB_NAME`              | The name of your database.                         | `localhost`             | `localhost`  |                 |
| `DB_USERNAME`          | The username for your database.                    | `root`                | `root`         |                 |
| `DB_PASSWORD`          | The password for your database.                    | `root`                | `root`         |                 |
| `DB_POOL`              | The database connection pool size.                 | `30`                  |                |                 |
| `RAPIDAPI_BASE_URL`     | The base URL for RapidAPI requests.                | *(required)*          | *(required)*   |                 |
| `RAPIDAPI_KEY`          | Your RapidAPI key for authentication.              | *(required)*          | *(required)*   |                 |
| `RAPIDAPI_HOST`         | The host for RapidAPI services.                    | *(required)*          | *(required)*   |                 |
| `AUTHENTICATION_SYSTEM` | The type of authentication system                  | `token`             | *(optional)*   | `session OR token` |
| `USE_WALLET_BALANCE_COLUMN` | The flag to whether use the balance column to get the current balance of wallet                  | `false`             | *(optional)*   | `false OR true` |

### Example Setup

To get started quickly, create a `.env` file in the root of your project or set the environment variables directly in your hosting environment.

```bash
# .env file for Development

DB_HOST=127.0.0.1
DB_NAME=my_database
DB_USERNAME=root
DB_PASSWORD=root
DB_POOL=30

RAPIDAPI_BASE_URL=https://api.example.com
RAPIDAPI_KEY=your-rapidapi-key
RAPIDAPI_HOST=example-host
AUTHENTICATION_SYSTEM=session
USE_WALLET_BALANCE_COLUMN=false
```
