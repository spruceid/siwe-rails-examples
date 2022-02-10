require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module SiweRails
  class Application < Rails::Application
    config.load_defaults 7.0

    config.x.siwe.prefix = 'siwe' # Prefix where the routes will be mounted
    config.x.siwe.redirect_uri = '/sign-in' # Redirect URL to receive user information on success

    config.x.siwe.network = 'mainnet' # Network to use with SIWE

    config.x.siwe.infura = '8fcacee838e04f31b6ec145eb98879c8' # Infura Key
    config.x.siwe.portis = '100e221a-2139-4543-8831-c53f5afefda6' # Portis ID
    config.x.siwe.fortmatic = 'pk_live_BF045EF8040D5F1C' # Fortmatic Key

    config.x.siwe.torus = true # Whether to enable Torus Wallet
    config.x.siwe.coinbase = true # Whether to enable Coinbase Wallet, requires Infura Key
  end
end
