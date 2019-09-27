class ApplicationController < ActionController::API
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  private

  def authentication_error
    error = {
      "status" => "401",
      "source" => { "pointer" => "/oauth_code" },
      "title" =>  "Authentication Code is invalid",
      "detail" => "Please provide a valid authentication code"
    }

    render json: { "errors" => [error] }, status: 401
  end
end
