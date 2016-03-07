json.id         post.id
json.user_id    post.user_id
json.slug       post.slug
json.title      post.title
json.content    post.content
json.date       post.date
json.publication_date       post.publication_date
json.status     post.status
json.post_type  post.post_type
json.category_id (post.category.nil? ? '' : post.category.id)
json.cover_image_url (post.cover_image? ? "#{request.base_url}/#{post.cover_image_path}" : "")
json.updated_at post.updated_at
json.created_at post.created_at

json.draft_path   request.base_url+wor_engine.post_preview_path(post)
json.public_path  request.base_url+post_path(post)

json.classifiers do
  json.array! post.classifiers do |classifier|
    json.partial! '/wor/api/v1/classifiers/classifier', {classifier: classifier}
  end
end

json.user do 
  if !post.user.nil?
    json.partial! '/wor/api/v1/users/user', {user: post.user}
  end
end