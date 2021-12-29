class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.where(address: session[:address]).first if session[:address]
  end
end
