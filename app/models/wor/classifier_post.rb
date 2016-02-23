class Wor::ClassifierPost < ActiveRecord::Base
  attr_accessible :post_id, :classifier_id

  self.table_name = :wor_classifier_posts

  belongs_to :classifier
  belongs_to :post

end
