module PaginatedCollection
  extend ActiveSupport::Concern
  
  included do
    # Include the pagination helper
    include Pagy::Backend
  end
  
  # Configure a paginated collection with Ransack search support
  # @param collection [ActiveRecord::Relation] The base collection to paginate
  # @param default_sort [String] Default sorting if none specified
  # @param includes [Array<Symbol>] Relations to eager load
  # @param per_page [Integer] Number of items per page
  # @param record [ActiveRecord::Base, nil] Optional record to determine the page
  # @return [Array] An array with the Pagy object and paginated collection
  def set_paginated_collection(collection, default_sort: nil, includes: nil, per_page: 10, record: nil)
    # Configure search with Ransack
    @q = collection.ransack(params[:q])
    @q.sorts = default_sort if default_sort.present? && @q.sorts.blank?
    
    # Apply search and inclusions
    collection_relation = @q.result(distinct: true)
    collection_relation = collection_relation.includes(includes) if includes.present?
    
    # Handle a specific record to determine the page
    if record.present?
      # Find the position of the record in the collection
      # Note: this may not be efficient for very large collections
      items = collection_relation.to_a
      if items.include?(record)
        position = items.index(record)
        page = (position / per_page).ceil + 1
        params[:page] = page
      end
    end
    
    # Configure pagination
    total_count = collection_relation.size
    total_pages = (total_count.to_f / per_page).ceil
    
    # Validate the requested page
    requested_page = params[:page].to_i
    requested_page = 1 if requested_page <= 0
    
    # Correct out of range pages
    if total_pages > 0 && requested_page > total_pages
      requested_page = 1
    end
    
    # Paginate the collection
    @pagy, paginated_items = pagy(collection_relation, items: per_page, page: requested_page)
    
    # Return the pagy object and paginated collection
    [@pagy, paginated_items]
  end
  
  # Returns a hash with the current pagination and search parameters
  # Useful for passing these parameters between requests and maintaining context
  # @return [Hash] Hash with pagination and search parameters
  def pagination_and_search_params
    {
      page_param: params[:page],
      search_params: params[:q]
    }
  end
end