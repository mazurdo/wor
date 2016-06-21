module Wor::WorTextsHelper

  def wor_simple_format(text, html_options = {}, options = {})
    wrapper_tag = options.fetch(:wrapper_tag, :p)

    text = sanitize(text) if options.fetch(:sanitize, true)
    paragraphs = wor_split_paragraphs(text)

    if paragraphs.empty?
      content_tag(wrapper_tag, nil, html_options)
    else
      paragraphs.map! { |paragraph|
        content_tag(wrapper_tag, raw(paragraph), html_options)
      }.join("\n\n").html_safe
    end
  end

  def wor_split_paragraphs(text)
    return [] if text.blank?

    text.to_str.gsub(/\r\n?/, "\n").split(/\n\n+/).map! do |t|
      # t.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') || t
      t
    end
  end

  def intro_text(post)
    return '' if post.content.blank?
    more = post.content.index("<!--more-->")
    return '' if more.nil?

    return post.content[0, more]
  end

  def convert_to_absolute_paths(content)
    doc = Nokogiri.HTML(content)

    if !doc.nil?
      doc.search('img').each do |img|
        if (!img.attributes['src'].value.include?('http://') && !img.attributes['src'].value.include?('https://'))
          img.attributes['src'].value = "#{request.protocol}#{request.host}#{img.attributes['src']}"
        end
      end

      doc.search('a').each do |link|
        if (!link.attributes['href'].value.include?('http://') && !link.attributes['href'].value.include?('https://'))
          link.attributes['href'].value = "#{request.protocol}#{request.host}#{link.attributes['href']}"
        end
      end

      doc.at("body").inner_html
    end
  end
end
