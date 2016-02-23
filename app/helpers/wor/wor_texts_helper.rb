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

end
