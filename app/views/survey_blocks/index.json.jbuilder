json.array!(@survey_blocks) do |survey_block|
  json.extract! survey_block, :id, :category, :weight
  json.url survey_block_url(survey_block, format: :json)
end
