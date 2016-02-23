module Wor
  module Slugs
    def self.sanitize(text)
      return nil if text.nil?
      _text = text.dup
      _text.gsub!(/[\\\/\:\*\?\"\'\>\<\$]/,'-')
      _text.gsub!(/[.]/,'')
      _text.gsub!('`','')
      _text.gsub!('´','')

      _text.to_url
    end
  end
end