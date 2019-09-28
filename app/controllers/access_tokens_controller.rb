class AccessTokensController < ApplicationController
  skip_before_action :authorized!, only: :create

  def create
    authenticator = UserAuthenticator.new(params[:oauth_code])
    authenticator.perform_authentication

    render json: authenticator.access_token, status: :created
  end

  def destroy
    current_user.access_token.destroy
  end
  
end
