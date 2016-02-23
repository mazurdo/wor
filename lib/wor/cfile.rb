module Wor
  class Cfile
    # PATH = File.join(Rails.public_path, "wor", "cover_images")

    def upload(file)
      return false if file.blank?

      # Eliminamos el fichero anterior si lo hay
      # remove_file

      # self.filename     = file.original_filename
      # self.extension    = filename.split('.').last
      # self.content_type = file.content_type
      # self.save

      File.open("#{PATH}#{id}.#{extension}", 'wb') do |_file|
        _file.write(file.read)
      end
    end

    # def file_path
    #   return "#{PATH}#{id}.#{extension}"
    # end

    # def url
    #   "http://localhost:3000/files/#{id}"
    # end

    # def image?
    #   return content_type.include?('image')
    # end

    # def remove_file
    #   if !extension.blank?
    #     file_path = "#{PATH}#{id}.#{extension}"
    #     File.delete(file_path) if File.exists?(file_path)
    #   end
    # end
  end
end