class Wor::ClassifierPost < ActiveRecord::Base
  self.table_name = :wor_classifier_posts

  belongs_to :classifier
  belongs_to :post

end
