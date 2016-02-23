require File.expand_path('../../../app/helpers/wor/wor_texts_helper.rb', __FILE__)

include ActionView::Helpers::OutputSafetyHelper
include ActionView::Helpers::TextHelper
include Wor::WorTextsHelper

require 'open-uri'

namespace :wor do
  desc "Import from WordPress"
  task :import_WP => :environment do
    (1..3).each do |i|
      if ARGV[i].blank?
        puts "Argument is required, example:\nrake wor:import_WP[database,host,username,password]"
        exit
      end
    end

    ActiveRecord::Base.establish_connection({ :adapter  => 'mysql2', 
                                              :database => ARGV[1], 
                                              :host     => ARGV[2], 
                                              :username => ARGV[3], 
                                              :password => (ARGV[4] || "")})

    posts = ActiveRecord::Base.connection.execute("SELECT ID, post_author, post_content, post_title, post_date, post_status, post_name, guid FROM qmblog_posts WHERE post_type='post' ORDER BY ID desc")

    post_tags = []
    post_categories = []
    posts.each_with_index do |post, index| 
      _tags = ActiveRecord::Base.connection.execute("
                      SELECT name 
                      FROM `qmblog_term_relationships` r
                      LEFT JOIN `qmblog_term_taxonomy` t ON t.term_id = r.term_taxonomy_id
                      LEFT JOIN `qmblog_terms` term ON term.`term_id`=t.term_id
                      WHERE `object_id`=#{post[0]} AND t.`taxonomy`='post_tag';")

      post_tags[index] = []
      _tags.each do |t|
        post_tags[index] << t[0]
      end

      _categories = ActiveRecord::Base.connection.execute("
                      SELECT name 
                      FROM `qmblog_term_relationships` r
                      LEFT JOIN `qmblog_term_taxonomy` t ON t.term_id = r.term_taxonomy_id
                      LEFT JOIN `qmblog_terms` term ON term.`term_id`=t.term_id
                      WHERE `object_id`=#{post[0]} AND t.`taxonomy`='category';")

      post_categories[index] = []
      _categories.each do |c|
        post_categories[index] << c[0] if c[0] != 'Uncategorized'
      end
    end


    @environment = ENV['RACK_ENV'] || 'development'
    @dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection @dbconfig[@environment]

    posts.each_with_index do |post, index|
      status = Wor::Post::PUBLISHED
      status = Wor::Post::DRAFT if post[5]=='draft' || post[5]=='auto-draft'

      _post = Wor::Post.create({user_id: post[1], 
                                slug: post[6], 
                                title: post[3].html_safe, 
                                content: simple_format(post[2]), 
                                publication_date: post[4], 
                                status: status, 
                                post_type: 'post',
                                disqus_identifier: "#{post[0]} #{post[7]}"})

      if !post_categories[index].blank?
        _post.add_classifier(post_categories[index][0] , 'category')
      end

      if !post_tags.blank?
        post_tags[index].each do |_tag|
          _post.add_classifier(_tag, 'tag') if !_tag.blank?
        end
      end

      # Import comments from Disqus
      if _post.published?
        begin
          response = DisqusApi.v3.get("threads/listPosts.json?thread=ident:#{_post.disqus_identifier}", forum: 'qucochemecompro')
          if response["code"]==0
            response["response"].each do |dcomment|
              Wor::Comment.create({post_id: _post.id, username: dcomment["author"]["name"], message: dcomment["message"], created_at: dcomment["createdAt"], disqus_object: dcomment.to_s})
            end
          else
            p "1- Error importando comentarios de: #{_post.disqus_identifier}"
          end
        rescue
          p "2- Error importando comentarios de: #{_post.disqus_identifier}"
        end
      end

      begin
        doc=Nokogiri.HTML(post[2])

        if !doc.nil?
          img = doc.search('img').first
          if !img.nil?
            img_url       = img.attributes['src'].value
            img_extension = img_url.split('.').last

            open("#{Wor::Post::PATH_COVER_IMAGE}/#{_post.id}.#{img_extension}", 'wb') do |file|
              file << open(img_url).read
            end

            if img.parent.name!="body"
              img.parent.remove
            else
              img.remove
            end

            post_content = wor_simple_format(doc.at('body').inner_html.lstrip.rstrip.html_safe, {}, sanitize: false)
            post_content.sub!("\n", "")
            post_content.sub!("<p><!--more--></p>", "<!--more-->") if post_content.include?("<p><!--more--></p>")
            post_content.sub!("<p>&nbsp;</p>", "")

            _post.update_attribute(:content, post_content) if !doc.at('body').nil?
            _post.update_attribute(:cover_image_ext, img_extension) if !img_extension.nil?
          end
        end
      rescue Exception => e
        p '--------------------------  ERROR  -----------------------------'
        p _post.inspect
        p e.inspect
        p '----------------------------------------------------------------'
      end
    end
  end
end

