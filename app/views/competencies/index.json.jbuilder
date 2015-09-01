json.array!(@competencies) do |competency|
  json.extract! competency, :id, :name, :description
  json.url competency_url(competency, format: :json)
end
