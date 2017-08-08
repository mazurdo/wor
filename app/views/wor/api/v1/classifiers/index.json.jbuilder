json.array! @classifiers do |classifier|
  json.partial! '/wor/api/v1/classifiers/classifier', {classifier: classifier}
end
