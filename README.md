# PHCDevworks Accounts Stytch

![Build Status](https://github.com/phcdevworks/phcdevworks_accounts_stytch/actions/workflows/test.yml/badge.svg)
![Gem Version](https://img.shields.io/gem/v/phcdevworks_accounts_stytch.svg)
![License](https://img.shields.io/github/license/phcdevworks/phcdevworks_accounts_stytch.svg)
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
![Last Commit](https://img.shields.io/github/last-commit/phcdevworks/phcdevworks_accounts_stytch.svg)
![Issues](https://img.shields.io/github/issues/phcdevworks/phcdevworks_accounts_stytch.svg)
  
![Forks](https://img.shields.io/github/forks/phcdevworks/phcdevworks_accounts_stytch.svg?style=social)
![Stars](https://img.shields.io/github/stars/phcdevworks/phcdevworks_accounts_stytch.svg?style=social)
[![Tweet](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2Fphcdevworks%2Fphcdevworks_accounts_stytch)](https://twitter.com/intent/tweet?text=Check%20out%20this%20authentication%20gem%20for%20Rails%20integrating%20with%20Stytch!%20https://github.com/phcdevworks/phcdevworks_accounts_stytch)

## Overview

PHCDevworks Accounts Stytch is an authentication system that integrates with the Stytch API to provide seamless B2B and B2C user authentication for Ruby on Rails apps. The project includes:

## Key Features:

- **Magic Link Authentication**: Users can authenticate via secure magic links sent to their email.
- **Password Authentication**: Support for password-based login and reset flows, including registration and session management.
- **Password Reset Management**: Users can reset their passwords via email, token, existing password, or session token.
- **Organization Support**: The B2B module includes organization-specific user authentication with integration of organization IDs.
- **Service Handling**: All service actions are abstracted into service objects that handle interaction with Stytch’s API for better maintainability and testability.
- **Error Handling & Logging**: Robust error logging and consistent handling of service responses ensure reliability and traceability of issues.

## Usage

### 1. Set up Stytch API credentials

You will need to store your Stytch API credentials securely in your Rails `credentials.yml.enc` file. Follow these steps to open and edit the credentials file:

1. Ensure you have the `master.key` file located in `config/master.key`.
2. Open the encrypted credentials file using the following command in your terminal:
```bash
rails credentials:edit
```
3. This will open the credentials file in your default text editor (or VSCode if configured). In the file, add your Stytch API credentials under both b2b and b2c keys, as shown below:
```yml
stytch:
  b2b:
    project_id: <your_b2b_project_id>
    secret: <your_b2b_secret>
  b2c:
    project_id: <your_b2c_project_id>
    secret: <your_b2c_secret>
```
4. Save and close the file. Rails will automatically re-encrypt the credentials.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "phcdevworks_accounts_stytch"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install phcdevworks_accounts_stytch
```

## Contributing
[![contributors](https://contributors-img.web.app/image?repo=phcdevworks/phcdevworks_accounts_stytch)](https://github.com/phcdevworks/phcdevworks_accounts_stytch/graphs/contributors)

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
