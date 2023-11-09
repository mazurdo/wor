require 'fileutils'

class Wor::Post < ActiveRecord::Base
  table_name =    :wor_posts

  has_paper_trail :class_name => 'Wor::Version',
                  :versions   => :versions,
                  :version    => :version,
                  :only       => [:title, :slug, :content, :publication_date, :user_id, :status]

  has_many        :classifier_posts, dependent: :destroy
  has_many        :classifiers,      through:   :classifier_posts
  has_many        :comments

  after_create    :hook_after_create
  after_update    :hook_after_update
  before_destroy  :hook_before_destroy

  scope           :published, lambda { where(["status=? and publication_date<=?", Wor::Post::PUBLISHED, Time.now]) }

  validates_presence_of  :user_id
  validates_presence_of  :title, :if => :published?

  PUBLISHED = 'published'
  DRAFT     = 'draft'
  PATH_COVER_IMAGE = File.join(Rails.public_path, "wor", "cover_images")


  def category
    return nil if self.classifiers.nil?
    return nil if self.classifiers.categories.nil?
    return self.classifiers.categories.first
  end

  def user
    return User.find(user_id) if !user_id.nil? && defined?(User) == 'constant'
    nil
  end

  def update_slug(_slug)
    slug_sanitize = Wor::Slugs.sanitize(_slug)
    _version = 0
    while Wor::Post.where("id<>? and slug=?", id, slug_sanitize).first
      _version += 1
      slug_sanitize    = "#{slug_sanitize}-#{_version}"
    end

    self.update({slug: slug_sanitize})
  end

  def published?
    status == PUBLISHED
  end

  def draft?
    status == DRAFT
  end

  def cover_image?
    File.exist?("#{PATH_COVER_IMAGE}/#{cover_image_name}")
  end

  def cover_image_name
    "#{id}.#{cover_image_ext}"
  end

  # TODO, Move to module
  def resize(path, image, size)
    return false if size.split('x').count!=2
    return false if !File.exist?(File.join(path))

    FileUtils.mkdir_p "#{path}/thumbnails/#{id}" if !File.exist?(File.join(path, 'thumbnails', id.to_s))

    image_original_path = "#{path}/#{image}"
    image_resized_path  = "#{path}/thumbnails/#{id}/#{size}_#{image}"

    width  = size.split('x')[0]
    height = size.split('x')[1]

    begin
      i = Magick::Image.read(image_original_path).first

      i.resize_to_fit(width.to_i,height.to_i).write(image_resized_path)
    rescue Exception => e
      Rails.logger.error e
    end

    true
  end

  def cover_image_path(size=nil)
    if cover_image?
      if size.nil?
        "wor/cover_images/#{cover_image_name}"
      elsif File.exist?("#{PATH_COVER_IMAGE}/thumbnails/#{id}/#{size}_#{cover_image_name}")
        "wor/cover_images/thumbnails/#{id}/#{size}_#{cover_image_name}"
      else
        "wor/cover_images/thumbnails/#{id}/#{size}_#{cover_image_name}" if resize(PATH_COVER_IMAGE, cover_image_name, size)
      end
    end
  end

  # TODO Move to module/helper
  def content_preprocess(size=nil)
    return content if size.nil? || content.blank?

    doc = Nokogiri.HTML(content)

    if !doc.nil?
      doc.search('img').each do |img|
        img_src  = img.attributes['src'].value
        image_name = img_src.split('/').last

        if !URI.parse(img_src).path.nil?
          image_path = URI.parse(img_src).path.gsub!(image_name, '')
          img_src.gsub!(image_name, '')

          if resize(File.join(Rails.public_path, image_path), image_name, size)
            img.attributes['src'].value = "#{img_src}thumbnails/#{id}/#{size}_#{image_name}"
          end
        end
      end

      doc.at("body").inner_html
    end
  end

  def upload_cover_image(file)
    remove_cover_image if cover_image?

    extension = file.original_filename.split('.').last

    File.open("#{PATH_COVER_IMAGE}/#{id}.#{extension}", 'wb') do |_file|
      _file.write(file.read)
    end

    update({cover_image_ext: extension})
  end

  def remove_cover_image
    FileUtils.rm_rf("#{PATH_COVER_IMAGE}/#{id}")
    File.delete("#{PATH_COVER_IMAGE}/#{cover_image_name}") if cover_image?
  end

  def related_posts(opts={})
    return nil if classifiers.nil? || classifiers.categories.nil? || classifiers.categories.count==0

    options = {limit: 5}.merge(opts)
    tag_ids = classifiers.tags.map(&:id)

    query   = Wor::Post.select("#{Wor::Post.table_name}.*")

    if tag_ids.count>0
      query = query.select("(SELECT COUNT(`tags`.id) FROM #{Wor::ClassifierPost.table_name} as `tags`
                             WHERE `tags`.`classifier_id` IN (#{tag_ids.join(',')})
                             AND `tags`.`post_id` = `qm_wor_posts`.`id`) as tags_count")
      query = query.order("tags_count desc")
    end

    query = query.joins(:classifier_posts)

    query = query.where("#{Wor::ClassifierPost.table_name}.classifier_id=? and
                         #{Wor::Post.table_name}.id<>? and
                         #{Wor::Post.table_name}.status=?", classifiers.categories.first.id, id, PUBLISHED)

    query = query.order("#{Wor::Post.table_name}.created_at desc")
    query = query.limit(options[:limit])
  end

  def add_classifier(name, type)
    slug = Wor::Slugs.sanitize(name)

    classifier = Wor::Classifier.where("slug=? and classifier_type=?", slug, type).first
    classifier = Wor::Classifier.create({name: name, classifier_type: type}) if classifier.nil?

    self.classifiers << classifier
    self.save
  end

  def sync_disqus
    begin
      response = DisqusApi.v3.get("threads/listPosts.json?thread=ident:#{self.disqus_identifier}", forum: Wor::Engine.disqus_forum)
      if response["code"]==0
        response["response"].each do |dcomment|
          if !Wor::Comment.sync?(dcomment["id"].to_i)
            Wor::Comment.create({ post_id: self.id,
                                  username: dcomment["author"]["name"],
                                  message: dcomment["message"],
                                  created_at: dcomment["createdAt"],
                                  disqus_object: dcomment.to_s})
          end
        end
      end
    rescue
        p "ERROR importing comments from #{self.disqus_identifier}"
    end
  end

  def self.find_by_category(category)
    c = Wor::Classifier.find_by_slug(category)
    return [] if c.blank?

    c.posts.order("publication_date desc")
  end

  def self.find_by_category_and_tags(category, tags)
    category = Wor::Classifier.find_by_slug(category)
    tags     = Wor::Classifier.tags.where("slug IN (?)", "#{tags}")

    return [] if category.nil?

    # post_ids to tags
    post_ids = Wor::Post.select("post_id")
                .joins(:classifier_posts)
                .where("classifier_id IN (?)", tags.map(&:id)).map(&:post_id)

    # post_ids to tags and category given
    post_ids = Wor::ClassifierPost.select("post_id")
                .where("classifier_id=? and post_id IN (?)", category.id, post_ids)
                .map(&:post_id)

    return [] if post_ids.nil?

    Wor::Post.where("#{Wor::Post.table_name}.id IN (?)", post_ids).order("publication_date desc")
  end

  private

  def hook_after_create
    self.update_slug(self.title)            if self.slug.blank? && !self.title.blank?
    self.update({status: DRAFT}) if self.status.blank?
  end

  def hook_after_update
    self.update({status: DRAFT})              if self.status.blank?
    self.update({publication_date: Time.now}) if self.published? && self.publication_date.blank?
    self.update_slug(self.title)                         if self.slug.blank? && !self.title.blank?
  end

  def hook_before_destroy
    self.remove_cover_image
  end
end
