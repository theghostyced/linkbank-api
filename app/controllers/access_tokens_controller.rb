class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:oauth_code])
    authenticator.perform_authentication
  end
end
