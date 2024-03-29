module OmniAuth
  module Strategies
    # Implements an OmniAuth strategy to get a Microsoft Graph
    # compatible token from Azure AD
    class Microsoft < OmniAuth::Strategies::OAuth2
      # include Devise::OmniAuth::UrlHelpers
      option :name, :microsoft

      DEFAULT_SCOPE = 'openid email profile'.freeze

      # Configure the Microsoft identity platform endpoints
      option :client_options,
             :site => ENV['AZURE_OAUTH_SITE_URL'],
             :authorize_url => ENV['AZURE_OAUTH_AUTHORIZE_ENDPOINT'],
             :token_url => ENV['AZURE_OAUTH_TOKEN_ENDPOINT']

      # Send the scope parameter during authorize
      option :authorize_options, [:scope]

      # Unique ID for the user is the sub field
      uid { raw_info['sub'] }

      # Get additional information after token is retrieved
      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        # Get user profile information from the /me endpoint
        @raw_info ||= decode_token
      end

      def decode_token
        keys = JSON.parse(URI.open(ENV['AZURE_OAUTH_JWKS_URL']).read)
        JWT.decode(access_token['id_token'], nil, true, { algorithms: ['RS256'], jwks: keys}).first
      end

      def authorize_params
        super.tap do |params|
          params[:scope] = request.params['scope'] if request.params['scope']
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      # Override callback URL
      # OmniAuth by default passes the entire URL of the callback, including
      # query parameters. Azure fails validation because that doesn't match the
      # registered callback.
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
