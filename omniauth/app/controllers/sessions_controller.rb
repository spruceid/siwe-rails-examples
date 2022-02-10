class SessionsController < ApplicationController
  def index
    p OmniAuth.strategies
    @strategies = OmniAuth.strategies
  end

  def create
    @omniauth = request.env['omniauth.auth'].to_hash
    flash.now[:notice] = 'OmniAuth authentication successful.'
  end

  def failure
    flash.now[:error] = 'OmniAuth authentication failed.'
  end
end
