class Wor::Comment < ActiveRecord::Base
  attr_accessible :post_id, :username, :message, :created_at, :disqus_object

  belongs_to :post


  def self.sync?(disqus_id)
    Wor::Comment.where("disqus_object like '%\"id\"=>\"?\"%'", disqus_id).size > 0
  end
end
