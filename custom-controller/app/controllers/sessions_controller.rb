require 'siwe'
require 'json'

class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render 'index'
  end

  def sign_in
    message = Siwe::Message.from_json_string session[:message]

    if message.verify(params.require(:signature), message.domain, message.issued_at, message.nonce)
      session[:message] = nil
      session[:ens] = params[:ens]
      session[:address] = message.address

      last_seen = DateTime.now
      User.upsert({ address: message.address, last_seen: last_seen })

      render json: { ens: session[:ens], address: session[:address], lastSeen: last_seen }
    else
      head :bad_request
    end
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

  def message
    nonce = Siwe::Util.generate_nonce
    message = Siwe::Message.new(
      request.host_with_port,
      params[:address],
      "#{request.protocol}#{request.host_with_port}",
      '1',
      {
        statement: 'SIWE Rails Example',
        nonce: nonce,
        chain_id: params[:chainId]
      }
    )

    session[:message] = message.to_json_string

    render plain: message.prepare_message
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
