json.array!(@test_scores) do |test_score|
  json.extract! test_score, :id
  json.url test_score_url(test_score, format: :json)
end
