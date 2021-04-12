class Wor::SitemapController < ApplicationController
  def index
    @posts = Wor::Post.published
                      .where('post_type=?', :post)
                      .group('MONTH(date), YEAR(date)')
                      .order('date asc')

    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  def categories
    @categories = Wor::Classifier.categories

    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  def tags
    @tags = Wor::Classifier.tags

    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  def posts
    @posts = Wor::Post.published.order('id desc')

    if params[:date].present?
      date = Date.parse(params[:date])
      @posts = @posts.where('post_type=? and date between ? and ?', :post, date.beginning_of_month, date.end_of_month)
    end

    if params[:classifier].present?
      c = Wor::Classifier.find_by_slug(params[:classifier])
      @posts = @posts.joins(:classifier_posts).where("#{Wor::ClassifierPost.table_name}.classifier_id=?", c)
    end

    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
