require 'siwe_rails'
require 'json'

class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render 'index'
  end

  def sign_in
    session[:ens] = session[SiweRails.SIWE_ENS]
    session[:address] = session[SiweRails.SIWE_ADDRESS]

    last_seen = DateTime.now
    User.upsert({ address: session[:address], last_seen: last_seen })

    render json: { ens: session[:ens], address: session[:address], lastSeen: last_seen }
  end

  def profile
    if current_user
      current_user.seen
      current_user.save
      render json: { ens: session[:ens], address: session[:address], lastSeen: current_user.last_seen }
    else
      head :no_content
    end
  end

  def sign_out
    if current_user
      current_user.seen
      current_user.save
      session[:ens] = nil
      session[:address] = nil
      head :no_content
    else
      head :unauthorized
    end
  end
end
