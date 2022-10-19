# frozen_string_literal: true

require 'application_system_test_case'

# System Test For Reposistories Page
class RepositoriesTest < ApplicationSystemTestCase

  test 'visiting the index' do
    visit repositories_path
    assert_text 'Search github repositeries by name'
  end

  test 'search with valid keyword' do
    VCR.use_cassette('valid_repositories') do
      visit repositories_path
      assert_text 'Search github repositeries by name'
      fill_in 'keyword', with: 'pallavi'
      click_on 'Search Repositories'
      page.has_selector?('td[data-name-id="item_name_0"]', text: '/pallavi/')
    end
  end

  test 'search with invalid keyword' do
    visit repositories_path(keyword: '')
    fill_in 'keyword', with: ''
    click_on 'Search Repositories'
    assert_text 'Search github repositeries by name'
    assert_text 'No Results'
  end

  test 'search with valid page' do
    visit repositories_path
    fill_in 'keyword', with: 'pallavi'
    click_on 'Search Repositories'
    page.has_selector?('td[data-name-id="item_name_0"]', text: '/pallavi/')
    within 'div#pages' do
      click_on '3'
    end
    page.has_selector?('td[data-name-id="item_name_0"]', text: '/pallavi/')
  end
end
