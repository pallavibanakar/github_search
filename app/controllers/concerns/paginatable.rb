# frozen_string_literal: true

# Module for pagination
module Paginatable
  extend ActiveSupport::Concern

  def paginate_results(results, page, count)
    if results.is_a?(Array)
      Kaminari.paginate_array(results, total_count: total_count(count))
              .page(page).per(SEARCH_PER_PAGE)
    else
      results.page(page).per(SEARCH_PER_PAGE)
    end
  end

  def total_count(count)
    if count && count > SEARCH_LIMIT
      SEARCH_LIMIT
    else
      count
    end
  end
end
