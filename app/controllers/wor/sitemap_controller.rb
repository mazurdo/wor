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
    date = Date.parse(params[:date])
    @posts = Wor::Post.published
                      .where('post_type=? and date between ? and ?', :post, date.beginning_of_month, date.end_of_month)
                      .order('id desc')

    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
