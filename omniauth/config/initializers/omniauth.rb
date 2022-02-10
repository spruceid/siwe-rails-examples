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
    identifier: '4eaa2d76-7d20-47ac-922a-f77927775aeb',
    secret: '45559d69-8fb5-4acc-8094-624e405c6c54'
  }

  provider :siwe, issuer: 'https://oidc.login.xyz/', client_options: client_options
end
