class Wor::PostsController < Wor::BaseController
  include Wor::PathsHelper

  def index
    if !params[:id].blank?
      @post = Wor::Post.find_by_id(params[:id])
      redirect_to post_path(@post), :status => :moved_permanently
    else
      @posts = Wor::Post.published
    end
  end

  def show
    @post = Wor::Post.find_by_slug(params[:slug])
    authorize @post

    respond_to do |format|
      format.html { render_show(@post) }
      format.rss { render :layout => false }
    end
  end

  def preview
    @post = Wor::Post.find_by_id(params[:id])
    authorize @post

    render_show(@post)
  end


  private

  def render_show(post)
    if !post.layout.blank?
      render post.layout
    else
      render :show
    end
  end
end