module Wor::PathsHelper

  def post_path(post)
    wor_engine.post_path(post)
  end

  def category_path(category)
    wor_engine.category_path(category)
  end

  def tag_path(tag)
    wor_engine.tag_path(tag)
  end

end
