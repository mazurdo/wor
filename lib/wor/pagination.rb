module Wor
  class Pagination
    attr_accessor :current_page, :total_pages, :total_items, :total_current_items, :per_page

    def initialize(opts={})
      options = {current_page: 1, total_pages: 0, total_items: 0, total_current_items: 0}.merge(opts)

      @current_page         = options[:current_page].to_i if !options[:current_page].blank?
      @current_page         = 1 if @current_page.nil? or @current_page.to_i<1

      @total_pages          = options[:total_pages]
      @total_items          = options[:total_items]
      @total_current_items  = options[:total_current_items]

      @per_page             = options[:per_page]
    end

  end
end