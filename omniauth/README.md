# Omniauth SIWE

Sign In With Ethereum OIDC OmniAuth example based on
[omniauth-test-harness](https://github.com/PracticallyGreen/omniauth-test-harness).

More details about the SIWE OmniAuth gem can be found in this
[README](https://github.com/spruceid/omniauth-siwe#readme)

## Obtaining OIDC Credentials

To be able to use [`oidc.login.xyz`](https://oidc.login.xyz) you
will need to register as a client. To do that, use the following
command, filling out your own `redirect_uris`, according to your
setup.

```bash
curl -X POST 'https://oidc.login.xyz/register' \
  -H 'Content-type: application/json' \
  --data '{"redirect_uris": ["http://localhost:3000/auth/siwe/callback"]}'
```

That should output a json object similar to the one below with
your `client_id` and `client_secret`:

```json
{"client_id":"your-client-id","client_secret":"your-client-secret","registration_access_token":"your-registration-access-token","registration_client_uri":"your-registration-client-uri","redirect_uris":["http://localhost:3000/auth/siwe/callback"]}%
```

In this case, since we're running this example on `localhost:3000`,
we need the `redirect_uris` to contain `http://localhost:3000/auth/siwe/callback`.

After registering, you have to set the client id and secret in the
provider configuration file `config/initializers/omniauth.rb`:

```diff
  client_options = {
    scheme: 'https',
    host: 'oidc.login.xyz',
    port: 443,
    authorization_endpoint: '/authorize',
    token_endpoint: '/token',
    userinfo_endpoint: '/userinfo',
    jwks_uri: '/jwk',
-    identifier: '',
-    secret: ''
+    identifier: 'your-client-id',
+    secret: 'your-client-secret'
  }

  provider :siwe, issuer: 'https://oidc.login.xyz/', client_options: client_options
```

## Setup & Running

**You might need to either change the Gemfile's Ruby version, or install
Ruby 3.1.0.**

Install the dependencies with:

```
bundle install
```

Run the server with:

```bash
bundle exec rails server
```
