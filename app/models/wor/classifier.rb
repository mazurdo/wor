class Wor::Classifier < ActiveRecord::Base
  self.table_name = :wor_classifiers

  has_many :classifier_posts
  has_many :posts, -> { order('publication_date desc') }, through: :classifier_posts

  scope :categories, -> { where(classifier_type: :category) }
  scope :tags, -> { where(classifier_type: :tag) }

  after_create :after_create

  def update_slug(_slug)
    slug_sanitize = Wor::Slugs.sanitize(_slug)
    _version = 0

    while Wor::Classifier.where("id<>? and slug=? and classifier_type=?", id, slug_sanitize, classifier_type).first
      _version += 1
      slug_sanitize = "#{slug_sanitize}-#{_version}"
    end

    update(slug: slug_sanitize)
  end

  private

  def after_create
    update_slug(name)
  end
end
