class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  before_action :authorized!

  private

  def access_token
    client_auth_token = request.authorization&.gsub(/\ABearer\s/, '')
    @access_token = AccessToken.find_by(token: client_auth_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  def authentication_error
    error = {
      "status" => "401",
      "source" => { "pointer" => "/oauth_code" },
      "title" =>  "Authentication Code is invalid",
      "detail" => "Please provide a valid authentication code"
    }

    render json: { "errors" => [error] }, status: 401
  end

  def authorization_error
    error = {
      "status" => "403",
      "source" => { "pointer" => "/headers/authorization" },
      "title" =>  "Forbidden Error",
      "detail" => "You are not allowed to access this resource"
    }

    render json: { "errors" => [error] }, status: 403
  end

  def authorized!
    raise AuthorizationError unless current_user
  end
end
