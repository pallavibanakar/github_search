# frozen_string_literal: true

# Controller to search for repositories
class RepositoriesController < ApplicationController
  include Paginatable

  def index
    @results = search if search_params[:keyword].present?
    respond_to do |format|
      format.html
      format.json do
        render json: @results
      end
    end
  end

  private

  def search
    github_client = Services::Github::Client.new(
      Rails.application.credentials.dig(Rails.env.to_sym, :github_acess_token)
    )
    search_results(
      github_client.search_repo_names(
        search_params[:keyword],
        (search_params[:page] || 1),
        SEARCH_PER_PAGE
      )
    )
  end

  def search_results(results)
    if results['items']
      paginate_results(results['items'], search_params[:page], results['total_count'])
    elsif results[:error]
      flash[:notice] = results[:error]
      nil
    end
  end

  def search_params
    params.permit(:keyword, :page)
  end
end
