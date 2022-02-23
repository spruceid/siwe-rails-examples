Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/auth'
    config.allowed_request_methods = %i[post get]
  end

  client_options = {
    scheme: 'https',
    host: 'oidc.login.xyz',
    port: 443,
    authorization_endpoint: '/authorize',
    token_endpoint: '/token',
    userinfo_endpoint: '/userinfo',
    jwks_uri: '/jwk',
    identifier: '',
    secret: ''
  }

  provider :siwe, issuer: 'https://oidc.login.xyz/', client_options: client_options
end
