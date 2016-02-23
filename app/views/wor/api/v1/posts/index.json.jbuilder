json.array! @posts do |post|
  json.partial! '/wor/api/v1/posts/post', {post: post}
end