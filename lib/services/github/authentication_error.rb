# frozen_string_literal: true

module Services
  module Github
    # AuthenticationError is raised when invalid credentials are provided
    class AuthenticationError < GithubError
    end
  end
end
