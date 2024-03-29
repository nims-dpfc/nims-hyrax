class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # skip_before_action :set_user

  def microsoft
    # Access the authentication hash for omniauth
    data = request.env['omniauth.auth']
    # save_in_session data
    user = User.from_omniauth(data)
    sign_in_and_redirect user
  end

  def signout
    reset_session
    redirect_to root_url
  end

  private
  def save_in_session(auth_hash)
    # Save the token info
    session[:graph_token_hash] = auth_hash[:credentials]
    # Save the user's display name
    session[:user_name] = auth_hash.dig(:extra, :raw_info, :displayName)
    # Save the user's email address
    # Use the mail field first. If that's empty, fall back on
    # userPrincipalName
    session[:user_email] = auth_hash.dig(:extra, :raw_info, :mail) ||
      auth_hash.dig(:extra, :raw_info, :userPrincipalName)
    # Save the user's time zone
    session[:user_timezone] = auth_hash.dig(:extra, :raw_info, :mailboxSettings, :timeZone)
  end

  # def access_token
  #   token_hash = session[:graph_token_hash]
  #
  #   # Get the expiry time - 5 minutes
  #   expiry = Time.at(token_hash[:expires_at] - 300)
  #
  #   if Time.now > expiry
  #     # Token expired, refresh
  #     new_hash = refresh_tokens token_hash
  #     new_hash[:token]
  #   else
  #     token_hash[:token]
  #   end
  # end
  #
  # def refresh_tokens(token_hash)
  #   oauth_strategy = OmniAuth::Strategies::MicrosoftGraphAuth.new(
  #     nil, ENV['AZURE_APP_ID'], ENV['AZURE_APP_SECRET']
  #   )
  #
  #   token = OAuth2::AccessToken.new(
  #     oauth_strategy.client, token_hash[:token],
  #     :refresh_token => token_hash[:refresh_token]
  #   )
  #
  #   # Refresh the tokens
  #   new_tokens = token.refresh!.to_hash.slice(:access_token, :refresh_token, :expires_at)
  #
  #   # Rename token key
  #   new_tokens[:token] = new_tokens.delete :access_token
  #
  #   # Store the new hash
  #   session[:graph_token_hash] = new_tokens
  # end

end
