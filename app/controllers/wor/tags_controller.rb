class Wor::TagsController < Wor::BaseController

  def show
    @tag = Wor::Classifier.tags.find_by_slug(params[:slug])

    @posts = @tag.posts.published.order("publication_date desc")

    @pagination = Wor::Pagination.new({current_page: params[:page], total_items: @posts.count})
    @posts      = @posts.paginate(page: @pagination.current_page, per_page: 20)
    @pagination.total_pages           = @posts.total_pages
    @pagination.total_current_items   = @posts.size
    @pagination.per_page              = @posts.per_page

    @canonical = request.base_url+view_context.tag_path(@tag)
  end

end
