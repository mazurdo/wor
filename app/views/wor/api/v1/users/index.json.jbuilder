json.array! @users do |user|
  json.partial! '/wor/api/v1/users/user', {user: user}
end