json.array! @versions do |version|
  json.partial! '/wor/api/v1/versions/version', {version: version}
end 