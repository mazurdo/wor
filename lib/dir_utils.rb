# def directory_hash(path, name=nil)
#   data = {:data => (name || path)}
#   data[:children] = children = []
#   Dir.foreach(path) do |entry|
#     next if (entry == '..' || entry == '.')
#     full_path = File.join(path, entry)
#     if File.directory?(full_path)
#       children << directory_hash(full_path, entry)
#     else
#       children << entry
#     end
#   end
#   return data
# end

# Recursively build a hash for directory listing
def create_hash(path, name = nil)
  data = {:name => name, :path => path}
  data[:children] = children = []
  Dir.foreach(path) do |entry|
    next if entry == '..' or entry == '.'
    full_path = File.join(path, entry)
    if File.directory?(full_path)
      children << create_hash(full_path, entry)
    # else
    #   children << entry
    end
  end
  return data
end

# def rec_path(path, file= false)
#   puts path
#   path.children.collect do |child|
#     if file and child.file?
#       child
#     elsif child.directory?
#       rec_path(child, file) + [child]
#     end
#   end.select { |x| x }.flatten(1)
# end