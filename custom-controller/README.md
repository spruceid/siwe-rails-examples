# custom-controller

This is an example of how to add SIWE to a Rails
application. For that it has two main endpoints:

- `/message`: to obtain the SIWE message to sign;
- `/sign_in`: to verify the signature and sign in/up the user when valid.

It uses the `siwe-ruby` library to generate and verify
the message. For more details on the library,
[go here](https://github.com/spruceid/siwe-ruby).

For other ways to add SIWE to your Ruby/Rails application,
please look at the other examples in this repository.

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
