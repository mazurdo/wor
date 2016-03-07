class Wor::Api::V1::PostsController < Wor::Api::V1::BaseController
  def index
    @posts = Wor::Post.where(true)
    @posts = @posts.where("title like ?", "%#{params[:title]}%")  if !params[:title].blank?
    @posts = @posts.where("user_id=?", params[:user_id])          if !params[:user_id].blank?
    @posts = @posts.where("status=?",  params[:status])           if !params[:status].blank?
    @posts = @posts.where("date >= ?", params[:date_begin]) if !params[:date_begin].blank?
    @posts = @posts.where("date <= ?", params[:date_end])   if !params[:date_end].blank?

    _classifier_ids = []
    _classifier_ids << params[:category_id] if !params[:category_id].blank?
    _classifier_ids << params[:tag_id]      if !params[:tag_id].blank?

    if _classifier_ids.count > 0
      @posts = @posts.joins(:classifier_posts).where("#{Wor::ClassifierPost.table_name}.classifier_id IN (?)", _classifier_ids)
    end

    @posts = @posts.order("date desc, created_at desc")

    @pagination = Wor::Pagination.new({current_page: params[:page], total_items: @posts.count})
    @posts      = @posts.paginate(page: @pagination.current_page, per_page: 20)
    @pagination.total_pages           = @posts.total_pages
    @pagination.total_current_items   = @posts.size
    @pagination.per_page              = @posts.per_page

    render_message({view: :index})#({view: :create, messages: ["Se ha creado el lead correctamente"]})
  end

  def show
    @post = Wor::Post.find(params[:id])

    render_message({view: :show})
  end

  def update
    @post = Wor::Post.find(params[:id])

    @post.update_slug(params[:slug])

    attrs_to_update = {title: params[:title], content: params[:content], user_id: params[:user_id], publication_date: params[:publication_date]}

    if params[:status]==Wor::Post::PUBLISHED && !@post.published?
      attrs_to_update[:publication_date]   = Time.now
      attrs_to_update[:disqus_identifier]  = "#{request.base_url}/#{wor_engine.posts_path}?id=#{@post.id}" if @post.disqus_identifier.nil?
      attrs_to_update[:permalink]          = "#{request.base_url}/#{wor_engine.posts_path}?id=#{@post.id}" if @post.permalink.nil?
    end

    if params[:status]==Wor::Post::PUBLISHED || params[:status]==Wor::Post::DRAFT
      @post.update_attributes({status: params[:status]})
    end

    if @post.publication_date.blank?
      attrs_to_update[:date] = Time.now
    end

    @post.update_attributes(attrs_to_update)

    Wor::ClassifierPost.where("post_id=?", @post.id).destroy_all
    Wor::ClassifierPost.create({post_id: @post.id, classifier_id: params[:category_id]}) if params[:category_id]

    if !params[:tags].nil?
      params[:tags].each do |tag_id|
        if !Wor::Classifier.exists?(tag_id)
          _tag = Wor::Classifier.create({name: tag_id, classifier_type: :tag})
          tag_id = _tag.id
        end

        Wor::ClassifierPost.create({post_id: @post.id, classifier_id: tag_id})
      end
    end

    if @post.valid?
      render_message({view: :show})
    else
      render_model_error(@post)
    end
  end

  def create
    @post = Wor::Post.create({title: params[:title], 
                              content: params[:content], 
                              user_id: (wor_current_user.nil? ? nil : wor_current_user.id),
                              date: Time.now})

    render_message({view: :show})
  end

  def upload_cover_image
    @post = Wor::Post.find(params[:post_id])
    @post.upload_cover_image(params[:file]) if params[:file]

    render_message({view: :show})
  end

  def destroy
    post = Wor::Post.find(params[:id])
    post.destroy

    render_message({messages: ["Post eliminado correctamente"]})
  end
end
