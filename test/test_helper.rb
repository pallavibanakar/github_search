ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'vcr'

class ActiveSupport::TestCase

  VCR.configure do |config|
    config.cassette_library_dir = Rails.root.join('test/vcr_cassettes')
    config.hook_into :webmock
    config.ignore_localhost = true
    config.filter_sensitive_data('<ACCESS TOKEN>') { Rails.application.credentials.dig(Rails.env.to_sym, :github_acess_token) }
    config.allow_http_connections_when_no_cassette = true
  end
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
