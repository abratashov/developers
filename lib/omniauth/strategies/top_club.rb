module OmniAuth
  module Strategies
    class Abitant < OmniAuth::Strategies::OAuth2
      option :name, 'top_club'

      option :client_options, {
        site: configatron.abitant.url,
        authorize_path: "/oauth/authorize"
      }

      uid do
        raw_info["id"]
      end

      info do
        {name: raw_info["name"]}
      end

      def raw_info
        @raw_info ||= access_token.get('/api/user').parsed
      end
    end
  end
end
