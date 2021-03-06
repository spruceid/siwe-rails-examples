# rails-engine

This example is based on the `custom-controller` example in
this same repository, but instead uses [`siwe_rails`](https://github.com/spruceid/siwe_rails)
to set up the `/siwe/message` and `/siwe/signature` endpoints.

The `siwe_rails` gem will redirect the user to a configurable
endpoint after successfully verifying the signature, and then
the application can read the user's address and ens, if available,
in these session variables:

```ruby
session[SiweRails.SIWE_ENS]
session[SiweRails.SIWE_ADDRESS]
```

## Setup & Running

**You might need to either change the Gemfile's Ruby version, or install
Ruby 3.1.0.**

First, the database migrations need to be executed with the following
command:

```
bin/rails db:migrate RAILS_ENV=development
```

Install the dependencies with:

```
bundle install
```

Then run the server with:

```bash
bundle exec rails server
```
