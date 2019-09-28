class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :user, :access_token

  def initialize(oauth_code)
    @oauth_code = oauth_code
  end

  def perform_authentication
    raise AuthenticationError if oauth_code.blank?
    raise AuthenticationError if github_token.try(:error).present?
    user_client = Octokit::Client.new(
      access_token: github_token
    )

    # Filtering all the unnecessary data returned by GITHUB API
    user_data = user_client.user.to_h.slice(:login, :avatar_url, :url, :name)
    @user = check_user_existence(user_data)
    @access_token = check_token_existence() 
  end

  def check_user_existence(user_data)
    if User.exists?(login: user_data[:login])
      User.find_by(login: user_data[:login])
    else
      # Create our user with the data gotten from GITHUB
      User.create(user_data.merge(provider: 'github'))
    end
  end

  def check_token_existence
    if user.access_token.present?
      user.access_token
    else
      user.create_access_token
    end
  end

  private

  attr_reader :oauth_code

  def oktokit_client
    @oktokit_client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def github_token
    @token ||= oktokit_client.exchange_code_for_token(oauth_code)
  end
end 