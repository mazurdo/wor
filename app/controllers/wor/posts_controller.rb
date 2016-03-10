class Wor::PostsController < Wor::BaseController
  include Wor::PathsHelper
  caches_action :show, :cache_path => Proc.new {|c| 
    "#{c.params[:controller]}_#{c.params[:action]}_#{c.params[:slug_category]}_#{c.params[:slug]}"
  }

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
  end

  def preview
    @post = Wor::Post.find_by_id(params[:id])
    authorize @post

    render :show
  end
end