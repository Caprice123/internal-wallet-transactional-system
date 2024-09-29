# Internal Wallet Transactional System API

This repository contains 3 versions: version A, version B, and version C. Each is covering a different scenario. You can choose whichever scenario suits you the best and just use that version.

## Version A
Scenario being covered:

There are 3 types of accounts(UserAccount, TeamAccount, StockAccount) and their own wallet, with each of the account can do these actions:
1. They can deposit to their own wallet
2. They can withdraw from their own wallet
3. They can do transfer transaction from their own wallet to other account wallet

This version also contains a library to get the latest stock price from the `https://latest-stock-price.p.rapidapi.com` endpoints

This version also having 2 types of authentication system that MUST be configured at the start of the server, which are by built in session or by using token


## Version B
Scenario being covered:

There are 3 types of accounts(UserAccount, TeamAccount, StockAccount) with their own wallet, with each of the account can do these actions:
1. They can topup to their own wallet
2. They can deposit from their own wallet from other wallet (cannot be their own wallet)
3. They can withdraw from other wallet (cannot be their own wallet) to their own wallet

This version also contains a library to get the latest stock price from the `https://latest-stock-price.p.rapidapi.com` endpoints

This version also having 2 types of authentication system that MUST be configured at the start of the server, which are by built in session or by using token


## Version C
Scenario being covered:
There are one type of account with 3 types of wallets, with each of the account can do these actions:
1. They can deposit to their own wallet (either UserWallet, TeamWallet, or StockWallet)
2. They can withdraw from their own wallet (either UserWallet, TeamWallet, or StockWallet)

This version also contains a library to get the latest stock price from the `https://latest-stock-price.p.rapidapi.com` endpoints

This version also having 2 types of authentication system that MUST be configured at the start of the server, which are by built in session or by using token
