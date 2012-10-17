# -*- encoding : utf-8 -*-
require 'yajl'
require 'rest-client'

module Utils
  module I18none

    module GoogleLanguage
      def self.t(text, from, to)
        return '' if text.blank?
        base = 'https://www.googleapis.com/language/translate/v2'
        params = {
            :key => configatron.else.google_api_key,
            :format => 'html',
            :source => from,
            :target => to,
            :q => text
        }
        response = RestClient.post(base, params, 'X-HTTP-Method-Override' => 'GET')

        if response.code == 200
          json = MultiJson.decode(response)
          json['data']['translations'][0]['translatedText']
        else
          raise StandardError, response.inspect
        end
      end
    end

  end
end
