# frozen_string_literal: true

require 'test_helper'

module Services
  module Github
    # Test Github::Client
    class ClientTest < ActiveSupport::TestCase
      test 'should raise error if api_token is not provided.' do
        assert_raises(Services::Github::AuthenticationError, 'No API token provided.') do
          Services::Github::Client.new(nil)
        end
      end

      test 'search_repo_names with valid keyword and page' do
        VCR.use_cassette('valid_search_repo_names') do
          client = Services::Github::Client.new(
            Rails.application.credentials.dig(Rails.env.to_sym, :github_acess_token)
          )
          @results = client.search_repo_names('pallavi', 1, 30)
        end
        assert @results.key?('items')
        assert_not @results['items'].empty?
        assert (@results['total_count']).positive?
        assert @results['items'].size <= 30
        assert_includes @results['items'].first['name'], 'pallavi'
        private_flag = @results['items'].map { |item| item['private'] }.uniq
        assert private_flag, ['false']
      end
    end
  end
end
