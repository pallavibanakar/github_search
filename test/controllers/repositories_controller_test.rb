# frozen_string_literal: true

require 'test_helper'

# Test Repositories Controller
class RepositoriesControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get repositories_path
    assert_response :success
    assert_includes @response.body, '<!DOCTYPE html>'
    assert_includes @response.body, ERB::Util.html_escape('Search Repositories')
  end

  test 'should list results when searched with valid keyword' do
    VCR.use_cassette('valid_repositories') do
      get repositories_path,
          params: {
            keyword: 'pallavi'
          }
      assert_includes @response.body, '<!DOCTYPE html>'
      assert_includes @response.body, ERB::Util.html_escape('Name')
      assert_includes @response.body, ERB::Util.html_escape('Stars')
      assert_includes @response.body, ERB::Util.html_escape('Owner')
    end
  end

  test 'should show no results when no keyword given' do
    get repositories_path,
        params: {
          keyword: ''
        }
    assert_includes @response.body, '<!DOCTYPE html>'
    assert_includes @response.body, ERB::Util.html_escape('No Results')
  end

  test 'should list results when searched with valid keyword and page' do
    VCR.use_cassette('valid_repository_pages') do
      get repositories_path,
          params: {
            keyword: 'pallavi',
            page: 3
          }
      assert_includes @response.body, '<!DOCTYPE html>'
      assert_includes @response.body, ERB::Util.html_escape('Name')
      assert_includes @response.body, ERB::Util.html_escape('Stars')
      assert_includes @response.body, ERB::Util.html_escape('Owner')
    end
  end

  test 'should show error message with invalid page number' do
    VCR.use_cassette('invalid_repository_pages') do
      get repositories_path,
          params: {
            keyword: 'pallavi',
            page: 45
          }
      assert_includes @response.body, '<!DOCTYPE html>'
      assert_includes @response.body, ERB::Util.html_escape(
        'Only the first 1000 search results are available'
      )
      assert_includes @response.body, ERB::Util.html_escape('No Results')
    end
  end
end
