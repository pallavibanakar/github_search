# frozen_string_literal: true

module Services
  module Github
    # Github client
    class Client
      require 'uri'
      require 'net/http'
      require 'openssl'

      def initialize(api_token)
        @api_token = api_token
        check_credentials!(api_token: @api_token)
      end

      def search_repo_names(keyword, page, per_page)
        name_query = "#{keyword} in:name+in:public"
        query_string = "q=#{ERB::Util.url_encode(name_query)}&page=#{page}&per_page=#{per_page}"
        endpoint = "search/repositories?#{query_string}"
        parse_response(get(endpoint))
      end

      private

      def check_credentials!(api_token:)
        raise Github::AuthenticationError, 'No API token provided.' if api_token.blank?
      end

      def parse_response(response)
        case response
        when Net::HTTPSuccess
          JSON.parse response.body
        when Net::HTTPUnauthorized
          { error: "#{response.message}: Not Valid Request" }
        else
          { error: JSON.parse(response.body)['message'] }
        end
      end

      def get(endpoint)
        url = URI("https://api.github.com/#{endpoint}")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request['Authorization'] = "Bearer #{@api_token}"
        request['Accept'] = 'application/vnd.github+json'

        http.request(request)
      end
    end
  end
end
