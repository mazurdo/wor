module Wor
  module Api
    def self.error_serialize(errors)
      return if errors.nil?

      return errors.to_hash.map do |k, v|
        v.map do |msg|
          { id: k, title: msg }
        end
      end.flatten
    end
  end
end